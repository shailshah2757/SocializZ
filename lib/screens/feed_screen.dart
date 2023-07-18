import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:socializz/utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text(
          "SocializZ",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                LineAwesomeIcons.facebook_messenger,
                size: 23,
              ))
        ],
      ),
    );
  }
}
