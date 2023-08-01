import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:socializz/models/user.dart' as model;
import 'package:socializz/resources/storage_methods.dart';

//it is used to handle the authentication
class AuthMethods {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //retrieve the user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  //for user registration
  Future<String> signUpUser({
    required String email,
    required String password,
    required String aboutMe,
    required String username,
    required Uint8List file,
    // required Uint8List file,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          aboutMe.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        // print(userCredential.user?.uid);

        //it is used to store the images in the firebase storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          email: email,
          uid: userCredential.user!.uid,
          photoUrl: photoUrl,
          username: username,
          aboutMe: aboutMe,
          friends: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user.toJson());

        res = "Success";
      } else {
        res = "Please enter the details";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = "Email is not correctly formatted";
      } else if (e.code == 'email-already-exists') {
        res = "Email already exists";
      } else if (e.code == 'invalid-password') {
        res = "Password should be at least of 6 characters";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
      } else {
        res = "Please enter all the details";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "User not found";
      } else if (e.code == 'uid-already-exists') {
        res = "Username already exists";
      } else if (e.code == 'invalid-email') {
        res = "Email is not correctly formatted";
      } else if (e.code == 'invalid-password') {
        res = "Password should be at least of 6 characters";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
