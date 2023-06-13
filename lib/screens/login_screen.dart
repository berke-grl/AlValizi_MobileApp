import 'package:flutter/material.dart';
import 'package:graduation_app/resources/auth_method.dart';
import 'package:graduation_app/screens/signup_screen.dart';
import 'package:graduation_app/utils/utils.dart';
import 'package:graduation_app/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLogin = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logInUser() async {
    setState(() {
      _isLogin = true;
    });
    String res = await AuthMethods().logInUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    if (res == "success") {
      //navigate home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(res, context, Colors.red);
    }
    setState(() {
      _isLogin = false;
    });
  }

  void navigateToSignUpScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SignupScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              //LOGO
              const Icon(
                Icons.cases_outlined,
                color: Colors.black,
                size: 64,
              ),
              const Text(
                "AlValizi ",
                style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sacramento"),
              ),

              const SizedBox(height: 20),
              TextFieldInput(
                hintText: "Enter your Email",
                textInputType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return "Please enter a valid email address.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                hintText: "Enter your Password",
                textInputType: TextInputType.text,
                controller: _passwordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return "Please enter at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: logInUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: Colors.green),
                  child: _isLogin
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("Log In"),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              TextButton(
                onPressed: navigateToSignUpScreen,
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.green[300]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
