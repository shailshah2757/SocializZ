import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:socializz/models/memory.dart';
import 'package:socializz/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadMemories(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Some error occurred";

    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('memories', file, true);

      String memoryId = const Uuid().v1();

      Memory memory = Memory(
        description: description,
        uid: uid,
        memoryUrl: postUrl,
        username: username,
        memoryId: memoryId,
        datePublished: DateTime.now(),
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection('memories').doc(memoryId).set(memory.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> likeMemory(String memoryId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('memories').doc(memoryId).update(
          {
            'likes': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        _firestore.collection('memories').doc(memoryId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> addComment(String memoryId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('memories')
            .doc(memoryId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = "Success";
      } else {
        res = "Please enter some text";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteMemory(String memoryId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('memories').doc(memoryId).delete();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> friendUser(
    String uid,
    String friendId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(friendId)) {
        await _firestore.collection('users').doc(friendId).update(
          {
            'friends': FieldValue.arrayRemove([uid])
          },
        );

        await _firestore.collection('users').doc(uid).update(
          {
            'following': FieldValue.arrayRemove([friendId])
          },
        );
      } else {
        await _firestore.collection('users').doc(friendId).update(
          {
            'friends': FieldValue.arrayUnion([uid])
          },
        );

        await _firestore.collection('users').doc(uid).update(
          {
            'following': FieldValue.arrayUnion([friendId])
          },
        );
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
