import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'job_details_screen.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('My Posted Jobs'), backgroundColor: Colors.indigo, centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('jobs').where('userId', isEqualTo: userId).orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final jobs = snapshot.data!.docs;
          if (jobs.isEmpty) return const Center(child: Text('You have not posted any jobs yet', style: TextStyle(color: Colors.grey, fontSize: 16)));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final jobData = jobs[index].data() as Map<String, dynamic>;
              final jobId = jobs[index].id;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(jobData['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Price: ${jobData['price'] ?? ''} TND', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      StreamBuilder<QuerySnapshot>(
                        stream: firestore.collection('jobs').doc(jobId).collection('applications').snapshots(),
                        builder: (context, appSnapshot) {
                          final count = appSnapshot.hasData ? appSnapshot.data!.docs.length : 0;
                          return Text('Applicants: $count', style: const TextStyle(color: Colors.grey));
                        },
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailsScreen(jobId: jobId)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
