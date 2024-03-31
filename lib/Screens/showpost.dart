import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobspot_admin/Model/commentmodel.dart';
import 'package:jobspot_admin/Screens/Ecom.dart';

class instructionScreen extends StatefulWidget {
  final String userId;
  final String postId;
  final String image;
  final String topic;
  final String descrip;
  final VoidCallback onBackNavigate;

  const instructionScreen({
    Key? key,
    required this.userId,
    required this.postId,
    required this.image,
    required this.topic,
    required this.descrip,
    required this.onBackNavigate,
  }) : super(key: key);

  @override
  State<instructionScreen> createState() => _instructionScreenState();
}

class _instructionScreenState extends State<instructionScreen> {
  late Future<List<commentModel>> getComment;
  @override
  void initState() {
    super.initState();
    getComment = getIngredient(widget.userId, widget.postId);
  }

  Future<List<commentModel>> getIngredient(String userId, String postId) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.3.96/se_project/showcomment.php'));
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
  Future add_comment() async {
    var id = widget.userId;
    var postid = widget.postId;

    var uri = Uri.parse("http://192.168.3.96/se_project/comment.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = id;
    request.fields['post_id'] = postid;
    request.fields['comment'] = comment.text;

    print(id);
    print(postid);
    print(comment.text);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('comment Uploaded');
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
    } else {
      print('comment Not Uploaded');
    }
  }

  Future deletePost() async {
    var id = widget.postId;

    var uri = Uri.parse("http://192.168.3.96/se_project/deletePost.php");
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
      MaterialPageRoute(builder: (context) => Ecom()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 162, 53),
        title: Text('โพสต์'),
        leading: IconButton(
          onPressed: () {
            widget.onBackNavigate();
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
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Image.network(
                  'http://192.168.3.96/se_project/img/${widget.image}',
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      widget.topic,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      widget.descrip,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Comments',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'comment'),
                  controller: comment,
                ),
                Container(
                  child: TextButton(
                    onPressed: () {
                      add_comment();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: 5.0),
                        Text('comment'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<commentModel>>(
            future: getComment,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                final comments = snapshot.data!;
                return buildRecipe(comments);
              } else {
                return const Text('No comments available');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildRecipe(List<commentModel> getComment) => SizedBox(
        height: 200, // Adjust height as per your requirement
        child: ListView.builder(
          itemCount: getComment.length,
          itemBuilder: (context, index) {
            final recipe = getComment[index];
            return Card(
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          'http://192.168.3.96/se_project/img/${widget.image}',
                        ),
                      ),
                      title: Text(recipe.name),
                      subtitle: Text(recipe.comment),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
