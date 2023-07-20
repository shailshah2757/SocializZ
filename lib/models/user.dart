import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  late final String username;
  final String aboutMe;
  final List friends;
  final List following;

  User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.aboutMe,
    required this.friends,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "aboutMe": aboutMe,
        "friends": friends,
        "following": following
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      username: snapshot['username'] ?? 'shailshah',
      // username: snapshot['username'],
      aboutMe: snapshot['aboutMe'],
      friends: snapshot['friends'],
      following: snapshot['following'],
    );
  }
}
