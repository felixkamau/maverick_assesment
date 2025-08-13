import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class IntroOne extends StatelessWidget {
  const IntroOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset('assets/images/intro_one.png'),
            ),
            const SizedBox(height: 40),
            Text(
              "Welcome to your group and sacco management",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
