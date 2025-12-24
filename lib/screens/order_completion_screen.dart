import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderCompletionScreen extends StatelessWidget {
  final String jobId;

  const OrderCompletionScreen({super.key, required this.jobId});

  Future<void> markCompleted(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('jobs').doc(jobId).update({
      'status': 'completed',
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job marked as completed')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text('Order Completion'), backgroundColor: Colors.indigo),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('jobs').doc(jobId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'pending';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(data['description'] ?? '', style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 12),
                Text('Price: ${data['price'] ?? ''} TND', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Text('Status: $status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: status == 'completed' ? Colors.green : Colors.orange)),
                const Spacer(),
                if (status != 'completed')
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => markCompleted(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Mark as Completed', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
