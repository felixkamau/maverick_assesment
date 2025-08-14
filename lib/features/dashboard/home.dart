import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maverick/services/auth_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home dash"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 30,
              height: 30,
              // color: Colors.grey.withOpacity(.3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey),
                color: Colors.grey.withOpacity(.3),
              ),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              //user profile icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  CircleAvatar(child: Icon(Icons.person)),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              //TODO tx/group plots
            ],
          ),
        ),
      ),
    );
  }
}
