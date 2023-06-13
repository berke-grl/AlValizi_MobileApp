import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/screens/add_post_screen.dart';
import 'package:graduation_app/screens/map_screen.dart';
import 'package:graduation_app/screens/post_screen.dart';
import 'package:graduation_app/screens/profile_screen.dart';
import 'package:graduation_app/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const PostScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const MapScreen(),
  ProfileScreen(
    userID: FirebaseAuth.instance.currentUser!.uid,
  )
];
