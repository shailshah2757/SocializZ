import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socializz/screens/add_post_screen.dart';
import 'package:socializz/screens/feed_screen.dart';
import 'package:socializz/screens/profile_screen.dart';
import 'package:socializz/screens/search_screen.dart';

const webScreenSize = 600;

var homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text("notifications"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
