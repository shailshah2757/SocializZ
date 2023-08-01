import 'package:flutter/foundation.dart';
import 'package:socializz/models/user.dart';
import 'package:socializz/resources/auth_methods.dart';

//managing the user's data
class UserProvider with ChangeNotifier {
  //private property
  User? _user;  //it holds the current user's data

  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;
  // _user ??
  // User(
  //   username: "shailshah",
  //   email: "shailshah2772002@gmail.com",
  //   uid: "shailshah",
  //   aboutMe: "Flutter Dev",
  //   photoUrl: "url",
  //   friends: [''],
  //   following: [''],
  // );

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
