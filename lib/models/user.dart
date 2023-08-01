import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String aboutMe;
  final List friends;
  final List following;

  //Constructor calling
  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.aboutMe,
    required this.friends,
    required this.following,
  });

  //returns an instance of the User class 
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot["email"],
      uid: snapshot["uid"],
      photoUrl: snapshot["photoUrl"],
      username: snapshot["username"],
      // username: snapshot['username'],
      aboutMe: snapshot["aboutMe"],
      friends: snapshot["friends"],
      following: snapshot["following"],
    );
  }

  //Map<String, dynamic> maps a string key with the dynamic value
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "aboutMe": aboutMe,
        "friends": friends,
        "following": following,
      };
}
