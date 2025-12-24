import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobDetailsScreen extends StatelessWidget {
  final String jobId;

  const JobDetailsScreen({super.key, required this.jobId});

  Future<void> applyJob(BuildContext context, Map<String, dynamic> jobData) async {
    final user = FirebaseAuth.instance.currentUser!;
    final firestore = FirebaseFirestore.instance;

    final appliedRef = firestore.collection('jobs').doc(jobId).collection('applications').doc(user.uid);

    final applied = await appliedRef.get();
    if (applied.exists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You already applied')));
      return;
    }

    await appliedRef.set({
      'userId': user.uid,
      'userName': jobData['userName'],
      'appliedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application sent')));
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Job Details'), backgroundColor: Colors.indigo),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('jobs').doc(jobId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: data['userImage'] != null ? NetworkImage(data['userImage']) : null,
                      backgroundColor: Colors.indigo.shade100,
                      child: data['userImage'] == null ? const Icon(Icons.person, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 12),
                    Text(data['userName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 20),
                Text(data['title'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(data['description'] ?? '', style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 12),
                Text('Price: ${data['price'] ?? ''} TND', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => applyJob(context, data),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply for this Job', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
