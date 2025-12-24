import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatar extends StatefulWidget {
  final String imageUrl;
  final Function(File?) onImageSelected;

  const ProfileAvatar({super.key, required this.imageUrl, required this.onImageSelected});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? image;

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = File(picked.path));
      widget.onImageSelected(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: image != null ? FileImage(image!) : (widget.imageUrl.isNotEmpty ? NetworkImage(widget.imageUrl) : null) as ImageProvider?,
        backgroundColor: Colors.grey[300],
        child: image == null && widget.imageUrl.isEmpty ? const Icon(Icons.add_a_photo, color: Colors.white, size: 30) : null,
      ),
    );
  }
}
