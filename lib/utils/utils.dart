import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: imageSource);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image selected");
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
