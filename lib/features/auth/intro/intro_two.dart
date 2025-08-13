import 'package:flutter/material.dart';

class IntroTwo extends StatelessWidget {
  const IntroTwo({super.key});

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
              child: Image.asset('assets/images/intro_two.png'),
            ),
            const SizedBox(height: 40),
            Text(
              "Quick and secure access with your PIN, to manage your SACCO and groups",
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
