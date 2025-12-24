import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'job_details_screen.dart';

class FreelancerDashboardScreen extends StatelessWidget {
  const FreelancerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Applications'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collectionGroup('applications').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final applications = snapshot.data!.docs;
          if (applications.isEmpty) return const Center(child: Text('You have not applied to any jobs yet', style: TextStyle(color: Colors.grey, fontSize: 16)));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final appData = applications[index].data() as Map<String, dynamic>;
              final jobRef = applications[index].reference.parent.parent!;

              return FutureBuilder<DocumentSnapshot>(
                future: jobRef.get(),
                builder: (context, jobSnapshot) {
                  if (!jobSnapshot.hasData) return const SizedBox();
                  final jobData = jobSnapshot.data!.data() as Map<String, dynamic>;

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
                          Text('Posted by: ${jobData['userName'] ?? ''}', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('Price: ${jobData['price'] ?? ''} TND', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailsScreen(jobId: jobRef.id)));
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
