import 'package:flutter/material.dart';
import 'package:socializz/screens/add_post_screen.dart';
import 'package:socializz/screens/feed_screen.dart';
import 'package:socializz/screens/profile_screen.dart';
import 'package:socializz/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("notifications"),
  ProfileScreen(),
];
