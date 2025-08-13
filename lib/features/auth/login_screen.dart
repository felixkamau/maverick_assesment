import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:maverick/features/auth/signup_screen.dart';
import 'package:maverick/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text input controllers
  final _emailController = TextEditingController();
  final _pinController = TextEditingController();

  bool _obscure = false;

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  //Mem clean up controllers
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                //login animation
                // TODO decongest build Widget
                SizedBox(
                  width: 350,
                  height: 350,
                  child: Lottie.asset('assets/animations/signup_anime.json'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 5),
                TextField(
                  controller: _emailController,
                  cursorColor: Colors.grey,
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 114, 94, 1),
                        width: 3,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Email",
                    hint: Text("sacco@gmail.com"),
                  ),
                ),

                const SizedBox(height: 15),
                TextField(
                  obscureText: _obscure,
                  obscuringCharacter: '*',
                  controller: _pinController,
                  cursorHeight: 20,
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(255, 114, 94, 1),
                        width: 3,
                      ),
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Pin",
                    hint: Text("123456"),
                  ),
                ),

                const SizedBox(height: 15),
                button(
                  buttonTxt: "login",
                  buttonW: double.infinity,
                  buttonH: 50,
                  onPressed: () {},
                  buttonTxtStyle: TextStyle(color: Colors.white, fontSize: 18),
                  buttonColor: Color.fromRGBO(255, 114, 94, 1),
                ),

                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text(
                    "Don't have an account, signup",
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
