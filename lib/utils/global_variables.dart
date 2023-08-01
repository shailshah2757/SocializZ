import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socializz/screens/add_memory_screen.dart';
import 'package:socializz/screens/feed_screen.dart';
import 'package:socializz/screens/profile_screen.dart';
import 'package:socializz/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
    child: Text("Notifications Screen"),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
