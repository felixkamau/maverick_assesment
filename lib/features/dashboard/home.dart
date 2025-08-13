import 'package:flutter/material.dart';
import 'package:maverick/services/auth_service.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      appBar: AppBar(title: Text("Home dash")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Colors.grey,
                ),
              ),

              ElevatedButton(
                onPressed: authService.logOut,
                child: Text("logout"),
              ),
              // Analysis of sacco/group funds
            ],
          ),
        ),
      ),
    );
  }
}
