import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobspot_admin/Model/food.dart';
import 'package:jobspot_admin/Screens/Instruction.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Foodlist extends StatefulWidget {
  const Foodlist({super.key});

  @override
  State<Foodlist> createState() => _FoodlistState();
}

class _FoodlistState extends State<Foodlist> {
  Future<List<Food>> foodFuture = getFood();
  static Future<List<Food>> getFood() async {
    final response = await http.get(Uri.parse('http://192.168.3.96/se_project/view_product.php'));
    var data = json.decode(response.body);
    late SharedPreferences pref;
    pref = await SharedPreferences.getInstance();

    var FoodIndex = (data[0]["food_id"]);

    print(FoodIndex);

    await pref.setString('postid', FoodIndex);


    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map<Food>((json) => Food.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget buildPost(List<Food> post) => ListView.builder(
        itemCount: post.length,
        itemBuilder: (context, index) {
          final user = post[index];
          return InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => instructionsScreen(
          foodID :user.food_id,
          foodImg: user.food_img,
          foodName: user.food_name,
          description: user.description,
          instructions: user.instructions,
          onBackNavigate: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  },
  child: Card(
    child: ListTile(
      title: Text(user.food_name),
      subtitle: Text(user.description),
    ),
  ),
);
        }
      );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายการอาหารทั้งหมด',
        ),
      ),
      body: Center(child: FutureBuilder<List<Food>>(future: foodFuture, builder: (context, snapshot){if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                final recipe = snapshot.data!;
                return buildPost(recipe);
              } else {
                return const Text('no Food data');
              }}),),
    );
   

  }
}