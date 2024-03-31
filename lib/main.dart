import 'package:flutter/material.dart';
import 'package:jobspot_admin/Screens/Home.dart';

void main() {
  runApp(const JobSpotAdmin());
}

class JobSpotAdmin extends StatelessWidget {
  const JobSpotAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
