import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:graduation_app/resources/auth_method.dart';
import 'package:graduation_app/screens/login_screen.dart';
import 'package:graduation_app/utils/utils.dart';
import 'package:graduation_app/widgets/text_field_input.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null) {
      setState(() {
        _isLoading = true;
      });
      if (_image == null) {
        _isLoading = false;
        return showSnackBar(
            "Upsss you need a profile picture ! ", context, Colors.red);
      }
      String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          bio: _bioController.text,
          file: _image!);
      setState(() {
        _isLoading = false;
      });
      if (res != "success") {
        _isLoading = false;
        showSnackBar(res, context, Colors.green);
      } else {
        //navigate home screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ));
      }
    }
  }

  void navigateToLogInScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            margin: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //LOGO
                    const Text(
                      "AlValizi",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Sacramento"),
                    ),
                    //Icon
                    const Icon(
                      Icons.cases_outlined,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    "https://www.pngitem.com/pimgs/m/22-223968_default-profile-picture-circle-hd-png-download.png"),
                              ),
                        Positioned(
                          bottom: 0,
                          left: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: const Color(0xFFFFFFFF).withOpacity(0.6),
                            ),
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      height: 5,
                    ),
                    const SizedBox(height: 40),
                    TextFieldInput(
                      hintText: "Enter your Username",
                      textInputType: TextInputType.emailAddress,
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a username";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: "Enter your Email",
                      textInputType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
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
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return "Please enter at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFieldInput(
                      hintText: "Enter your Bio",
                      textInputType: TextInputType.emailAddress,
                      controller: _bioController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter at bio";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: signUpUser,
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
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : const Text("Sign Up"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: navigateToLogInScreen,
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.green[300]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
