import 'package:flutter/material.dart';
import 'package:jobspot_admin/Screens/Ecom.dart';
import 'package:jobspot_admin/Screens/Foodlist.dart';

class HomeScreen extends StatefulWidget {
  
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Ecom()));
              },
              child: Text('จัดการโพสทั้งหมด'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Foodlist()));
              },
              child: Text('จัดการรายการอาหารทั้งหมด'),
            ),
          ],
        ),
      ),
    );
  }
}
