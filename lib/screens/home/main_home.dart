import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tunijobs/models/user_model.dart';
import 'package:tunijobs/services/user_service.dart';
import 'package:tunijobs/screens/home/client_home.dart';
import 'package:tunijobs/screens/home/freelancer_home.dart';
import 'package:tunijobs/screens/profile/edit_profile_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  AppUser? currentUser;
  bool loading = true;

  void loadUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await UserService().getUser(uid);
    if (user == null || user.name.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
      return;
    }
    setState(() {
      currentUser = user;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return currentUser!.role.toLowerCase() == 'client'
        ? ClientHome(user: currentUser!)
        : FreelancerHome(user: currentUser!);
  }
}
