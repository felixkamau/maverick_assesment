import 'package:flutter/material.dart';
import 'package:maverick/features/auth/intro/intro_one.dart';
import 'package:maverick/features/auth/intro/intro_three.dart';
import 'package:maverick/features/auth/intro/intro_two.dart';
import 'package:maverick/features/auth/login_screen.dart';
import 'package:maverick/features/dashboard/home.dart';
import 'package:maverick/features/dashboard/wallet_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [IntroOne(), IntroTwo(), IntroThree()],
          ),

          // page indicators
          // _controller to keep track of what page we are on
          // count the number of pages we have
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text("skip"),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                // done or nxt
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          // TODO go home page/dash
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                // return Home();
                                // TODO mocking up wallet screen
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text("done"),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text("next"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
