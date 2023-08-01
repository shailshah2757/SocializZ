import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);

  if (file != null) {
    return await file.readAsBytes();
  }
  // print("No image selected");
}

// showSnackbar(String content, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
