import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobspot_admin/Model/commentmodel.dart';
import 'package:jobspot_admin/Screens/Ecom.dart';
import 'package:jobspot_admin/Screens/Home.dart';

import 'package:shared_preferences/shared_preferences.dart';

class instructionScreen extends StatefulWidget {
  final String userId;
  final String postId;
  final String image;
  final String userimage;
  final String topic;
  final String descrip;
  final VoidCallback onBackNavigate;

  const instructionScreen({
    Key? key,
    required this.userId,
    required this.postId,
    required this.image,
    required this.userimage,
    required this.topic,
    required this.descrip,
    required this.onBackNavigate,
  }) : super(key: key);

  @override
  State<instructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<instructionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<commentModel>> getComment;

  late SharedPreferences pref;
  late String username = "";
  late String id = "";
  String pic = "";

  Future<void> dud() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username').toString();
      id = pref.getString('id').toString();
      pic = pref.getString('pic').toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getComment = getIngredient(widget.userId, widget.postId);
    dud();
  }

  Future<List<commentModel>> getIngredient(String userId, String postId) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2/flutter_login/showcomment.php'));
      request.fields['user_id'] = userId;
      request.fields['post_id'] = postId;

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body
            .map<commentModel>((json) => commentModel.fromJson(json))
            .toList();
      } else {
        print('Server Error: ${response.statusCode}');
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load comments');
    }
  }

  TextEditingController comment = TextEditingController();

  Future addComment() async {
    var postid = widget.postId;

    var uri = Uri.parse("http://10.0.2.2/flutter_login/comment.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = id;
    request.fields['post_id'] = postid;
    request.fields['comment'] = comment.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      print('comment Uploaded');
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
      // Reload the comments after adding a new comment
      setState(() {
        getComment = getIngredient(widget.userId, widget.postId);
        comment.clear();
      });
    } else {
      print('comment Not Uploaded');
    }
  }

  Future deletePost() async {
    var id = widget.postId;

    var uri = Uri.parse("http://10.0.2.2/flutter_login/deletePost.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['post_id'] = id;

    print(id);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Post Deleted');
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
    } else {
      print('Post Not Deleted');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Ecom()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 162, 53),
        title: const Text('รายละเอียดโพส'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              deletePost();
            },
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'http://10.0.2.2/flutter_login/upload/${widget.image}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                widget.topic,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.descrip,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<commentModel>>(
                future: getComment,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final comments = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comments
                          .map((comment) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'http://10.0.2.2/flutter_login/upload/${comment.userimage}',
                                  ),
                                ),
                                title: Text(comment.name),
                                subtitle: Text(comment.comment),
                              ))
                          .toList(),
                    );
                  } else {
                    return const Text('No comments available');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
