import 'package:flutter/material.dart';
import 'package:maverick/features/auth/signup_screen.dart';

import '../../../widgets/button.dart';

class IntroThree extends StatelessWidget {
  const IntroThree({super.key});

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
              child: Image.asset('assets/images/intro_three.png'),
            ),
            const SizedBox(height: 40),
            Text(
              "Keep track of your group contributions and members.",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 35),

            button(
              buttonTxt: "Get Started",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignupScreen();
                    },
                  ),
                );
              },
              buttonTxtStyle: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              buttonColor: Color.fromRGBO(255, 114, 94, 1),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
