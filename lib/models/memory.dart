import 'package:cloud_firestore/cloud_firestore.dart';

class Memory {
  final String description;
  final String uid;
  final String memoryId;
  final String username;
  final DateTime datePublished;
  final String memoryUrl;
  final String profileImage;
  final likes;

  //Constructor calling
  Memory(
      {required this.description,
      required this.uid,
      required this.memoryUrl,
      required this.username,
      required this.memoryId,
      required this.datePublished,
      required this.profileImage,
      required this.likes});

  //returns an instance of the Memory class
  static Memory fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Memory(
      description: snapshot["description"],
      uid: snapshot["uid"],
      memoryUrl: snapshot["memoryUrl"],
      username: snapshot["username"],
      // username: snapshot['username'],
      likes: snapshot["likes"],
      profileImage: snapshot["profileImage"],
      datePublished: snapshot["datePublished"],
      memoryId: snapshot["memoryId"],
    );
  }

  //Map<String, dynamic> maps a string key with the dynamic value
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "memoryId": memoryId,
        "datePublished": datePublished,
        "profileImage": profileImage,
        "likes": likes,
        "memoryUrl": memoryUrl
      };
}
