import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:socializz/constants/constants.dart';
import 'package:socializz/resources/auth_methods.dart';
import 'package:socializz/screens/signin_screen.dart';
import 'package:socializz/utils/colors.dart';
import 'package:socializz/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _aboutMeController.dispose();
    _userNameController.dispose();
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void navigateToSignin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SigninScreen(),
      ),
    );
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        aboutMe: _aboutMeController.text.trim(),
        userName: _userNameController.text.trim(),
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'Success') {
      showSnackbar(res, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  // padding: EdgeInsets.all(40),
                  child: const Text(
                    "SocializZ",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Text(
                  "Sign up to get started",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                const SizedBox(
                  height: 50,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage(Constants.defaultProfilePicPath),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  icon: const Icon(Icons.person),
                  textEditingController: _userNameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  icon: const Icon(Icons.mail_outline_rounded),
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: !passwordVisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      hintText: "Enter your password",
                      filled: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  icon: const Icon(LineAwesomeIcons.pen),
                  textEditingController: _aboutMeController,
                  hintText: "Enter your about me",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: Colors.blue),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text(
                            "Sign up",
                            style:
                                TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Already have an account? ",
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
