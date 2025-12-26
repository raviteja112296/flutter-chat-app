import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key,required this.onPickImage});
final void Function(File pickedImage) onPickImage;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(
    source: ImageSource.gallery, // or ImageSource.camera
    imageQuality: 50,
    maxWidth: 150,
  );

  if (pickedImage == null) return;

  setState(() {
    _pickedImageFile = File(pickedImage.path);
  });
  widget.onPickImage(_pickedImageFile!);
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
  onTap: _pickImage,
  child: CircleAvatar(
    radius: 40,
    backgroundColor: Colors.grey,
    foregroundImage:
        _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
    child: _pickedImageFile == null
        ? const Icon(Icons.camera_alt, size: 30, color: Colors.white)
        : null,
  ),
),
  TextButton.icon(
    onPressed: _pickImage, 
    label: Text("Add Image",
    style: TextStyle(color: Theme.of(context).primaryColor),
    )
    ),
const SizedBox(height: 16),

      ],
    );
  }
}