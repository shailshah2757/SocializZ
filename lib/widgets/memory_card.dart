import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socializz/providers/user_provider.dart';
import 'package:socializz/resources/firestore_methods.dart';
import 'package:socializz/screens/comments_screen.dart';
import 'package:socializz/utils/colors.dart';
import 'package:socializz/utils/global_variables.dart';
import 'package:socializz/utils/utils.dart';
import 'package:socializz/widgets/like_animation.dart';

import '../models/user.dart' as model;

class MemoryCard extends StatefulWidget {
  final snap;
  const MemoryCard({
    super.key,
    required this.snap,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  // void getComments() async {
  //   try {
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('memories')
  //         .doc(widget.snap['memoryId'])
  //         .collection('comments')
  //         .get();

  //     commentLength = snap.docs.length;
  //   } catch (e) {
  //     showSnackbar(e.toString(), context);
  //   }

  //   setState(() {});
  // }

  getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('memories')
          .doc(widget.snap['memoryId'])
          .collection('comments')
          .get();

      commentLength = snap.docs.length;
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {});
  }

  deleteMemory(String memoryId) async {
    try {
      await FirestoreMethods().deleteMemory(memoryId);
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profileImage'].toString(),
                  ),
                ),  
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: ["Delete"]
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              deleteMemory(
                                                widget.snap['memoryId']
                                                    .toString(),
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container()
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likeMemory(
                  widget.snap['memoryId'].toString(),
                  user.uid,
                  widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['memoryUrl'].toString(),
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 120,
                  ),
                ),
              )
            ]),
          ),
          Row(
            children: <Widget>[
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () => FirestoreMethods().likeMemory(
                      widget.snap['memoryId'].toString(),
                      user.uid,
                      widget.snap['likes']),
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          LineAwesomeIcons.heart_1,
                          color: Colors.blue,
                        )
                      : const Icon(Icons.favorite_outline),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      memoryId: widget.snap['memoryId'].toString(),
                    ),
                  ),
                ),
                icon: const Icon(
                  LineAwesomeIcons.comment_dots_1,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  LineAwesomeIcons.share,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(LineAwesomeIcons.bookmark),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        memoryId: widget.snap['memoryId'].toString(),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all $commentLength comments",
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMEd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
