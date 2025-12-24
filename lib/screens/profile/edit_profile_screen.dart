import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tunijobs/models/user_model.dart';
import 'package:tunijobs/services/user_service.dart';
import 'package:tunijobs/widgets/profile_avatar.dart';
import 'package:tunijobs/screens/home_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final name = TextEditingController();
  final role = TextEditingController();
  final skills = TextEditingController();
  File? image;
  bool loading = false;

  void handleSave() async {
    setState(() => loading = true);
    final user = FirebaseAuth.instance.currentUser!;
    String imageUrl = '';
    if (image != null) imageUrl = await UserService().uploadImage(image!, user.uid);
    final newUser = AppUser(
      uid: user.uid,
      email: user.email!,
      name: name.text.trim(),
      role: role.text.trim(),
      imageUrl: imageUrl,
      skills: skills.text.trim().split(','),
    );
    await UserService().createUser(newUser);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileAvatar(imageUrl: '', onImageSelected: (f) => image = f),
              const SizedBox(height: 30),
              TextField(
                controller: name,
                decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: role,
                decoration: InputDecoration(labelText: 'Role (Freelancer / Client)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: skills,
                decoration: InputDecoration(labelText: 'Skills (comma separated)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: loading ? null : handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
