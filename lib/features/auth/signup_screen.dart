import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maverick/services/auth_service.dart';
import 'package:maverick/features/auth/login_screen.dart';
import 'package:maverick/widgets/button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _authService = AuthService();
  final _obscure = true;
  final _emailController = TextEditingController();
  final _pinAuthController = TextEditingController();
  final _pinAuthConfirmController = TextEditingController();

  // Signup
  void signup() async {
    final email = _emailController.text;
    final pinAuth = _pinAuthController.text;
    final pinAuthConfirmation = _pinAuthConfirmController.text;

    if (pinAuth != pinAuthConfirmation) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pin doesn't match")));

      return;
    }
    try {
      await _authService.signUpWithEmailAndPassword(email, pinAuthConfirmation);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error $e")));
      }
    }
  }

  // Controllers memory cleanup
  @override
  void dispose() {
    _emailController.dispose();
    _pinAuthController.dispose();
    _pinAuthConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  child: Lottie.asset(
                    'assets/animations/signup_anime.json',
                    width: 350,
                    height: 350,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 5),
                TextField(
                  // controller: _emailController,
                  cursorColor: Colors.grey,
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 114, 94, 1),
                        width: 2,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Email",
                    hint: Text("Email"),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  cursorColor: Colors.grey,
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: Icon(Icons.pin),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 115, 94, 1),
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Pin",
                    hint: Text("Auth Pin"),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  cursorColor: Colors.grey,
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: Icon(Icons.pin),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 115, 94, 1),
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Confirm auth pin",
                    hint: Text("Confirm auth Pin"),
                  ),
                ),

                SizedBox(height: 15),

                /// [replaced] with the button() widget
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Color.fromRGBO(255, 115, 94, 1),
                //       side: BorderSide.none,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     child: Text(
                //       "Signup",
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
                button(
                  buttonTxt: "Signup",
                  buttonW: double.infinity,
                  buttonH: 50,
                  onPressed: signup,
                  buttonTxtStyle: TextStyle(color: Colors.white),
                  buttonColor: Color.fromRGBO(255, 115, 94, 1),
                ),

                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen()
                      ),
                    );
                  },
                  child: Text(
                    "Have an account, login",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
