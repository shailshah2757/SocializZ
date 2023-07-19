import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socializz/models/memory.dart';
import 'package:socializz/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadMemories(String description, Uint8List file, String uid,
      String username, String profileImage) async {
    String res = "Some error occurred";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('memories', file, true);

      String memoryId = const Uuid().v1();

      Memory memory = Memory(
          description: description,
          uid: uid,
          memoryUrl: photoUrl,
          username: username,
          memoryId: memoryId,
          datePublished: DateTime.now(),
          profileImage: profileImage,
          likes: []);

      _firestore.collection('memories').doc(memoryId).set(memory.toJson());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likeMemory(String memoryId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('memories').doc(memoryId).update(
          {
            'likes': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        await _firestore.collection('memories').doc(memoryId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> addComment(String memoryId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
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
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> deleteMemory(String memoryId) async {
    try {
      await _firestore.collection('memories').doc(memoryId).delete();
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
