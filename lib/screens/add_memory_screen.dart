import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socializz/models/user.dart';
import 'package:socializz/providers/user_provider.dart';
import 'package:socializz/resources/firestore_methods.dart';
import 'package:socializz/utils/colors.dart';
import 'package:socializz/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Create a memory",
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
          ),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Click a photo",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Choose from gallery",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Cancel",
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.red),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addImage(String uid, String username, String profileImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadMemories(
          _descriptionController.text.trim(),
          _file!,
          uid,
          username,
          profileImage);

      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar(
            context,
            "Posted!",
          );
        }
        clearImage();
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Container(
            child: Center(
              child: ElevatedButton(
                  onPressed: () {
                    _selectImage(context);
                  },
                  child: const Text(
                    "Upload your memory",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                  )),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: clearImage, icon: const Icon(Icons.arrow_back)),
              title: const Text("Add your memory"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      addImage(user.uid, user.username, user.photoUrl),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Add a caption...',
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
