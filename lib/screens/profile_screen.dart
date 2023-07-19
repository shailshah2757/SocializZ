import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socializz/utils/colors.dart';
import 'package:socializz/utils/utils.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int memoryLength = 0;
  int friends = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var memorySnap = await FirebaseFirestore.instance
          .collection('memories')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      memoryLength = memorySnap.docs.length;

      userData = userSnap.data()!;
      friends = userSnap.data()!['friends'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['friends']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'].toString(),
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'].toString(),
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(memoryLength, "Memories"),
                                      buildStatColumn(friends, "Friends"),
                                      buildStatColumn(following, "Following")
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? FollowButton(
                                              text: "Edit Profile",
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              textColor: primaryColor,
                                              borderColor: Colors.grey,
                                              function: () {},
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: "Unfriend",
                                                  backgroundColor: primaryColor,
                                                  textColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () {},
                                                )
                                              : FollowButton(
                                                  text: "Friend",
                                                  backgroundColor: Colors.blue,
                                                  textColor: primaryColor,
                                                  borderColor: Colors.blue,
                                                  function: () {},
                                                )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 10, left: 5),
                        child: Text(
                          userData['username'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.only(bottom: ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1, left: 5),
                        child: Text(
                          userData['aboutMe'].toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('memories')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(
                              snap['memoryUrl'],
                            ),
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
