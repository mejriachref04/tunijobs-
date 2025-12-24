import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tunijobs/models/user_model.dart';
import 'dart:io';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!);
  }

  Future<void> updateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<String> uploadImage(File file, String uid) async {
    final ref = _storage.ref().child('profiles/$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
