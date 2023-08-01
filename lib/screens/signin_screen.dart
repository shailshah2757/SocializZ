import 'package:flutter/material.dart';
import 'package:socializz/resources/auth_methods.dart';
import 'package:socializz/screens/signup_screen.dart';
import 'package:socializz/utils/colors.dart';
import 'package:socializz/utils/global_variables.dart';
import 'package:socializz/utils/utils.dart';
import 'package:socializz/widgets/text_field_input.dart';

import '../constants/constants.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signInUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (res == "Success") {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout())),
            (route) => false);

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Image.asset(Constants.loginBgPath),
                ),
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 35,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFieldInput(
                  icon: const Icon(Icons.mail_outline_rounded),
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 30,
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
                  height: 35,
                ),
                InkWell(
                  onTap: signInUser,
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
                            "Sign in",
                            style:
                                TextStyle(fontFamily: 'Poppins', fontSize: 18),
                          ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
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
