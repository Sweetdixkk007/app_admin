import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobspot_admin/Screens/Foodlist.dart';

class instructionsScreen extends StatefulWidget {
  final String foodImg;
  final String foodName;
  final String description;
  final String instructions;
  final String foodID;
  final VoidCallback onBackNavigate;

  const instructionsScreen({
    Key? key,
    required this.foodImg,
    required this.foodName,
    required this.description,
    required this.instructions,
    required this.foodID,
    required this.onBackNavigate,
  }) : super(key: key);

  @override
  State<instructionsScreen> createState() => _instructionsScreenState();
}

class _instructionsScreenState extends State<instructionsScreen> {
  Future deleteFood() async {
    var id = widget.foodID;

    var uri = Uri.parse("http://192.168.3.96/se_project/deletefood.php");
    var request = http.MultipartRequest('POST', uri);

    request.fields['food_id'] = id;

    print(id);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Food Deleted');
      String responseBody = await response.stream.bytesToString();
      print(responseBody);
    } else {
      print('Food Not Deleted');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Foodlist()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 162, 53),
        title: Text('ข้อมูลอาหาร'),
        leading: IconButton(
          onPressed: () {
            widget.onBackNavigate();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              deleteFood();
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
                  'http://192.168.3.96/se_project/img/${widget.foodImg}',
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      widget.foodName,
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
                      widget.description,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.instructions,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
