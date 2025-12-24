import 'package:flutter/material.dart';
import 'package:tunijobs/models/user_model.dart';
import 'package:tunijobs/screens/profile/edit_profile_screen.dart';
import 'package:tunijobs/widgets/job_card.dart';

class FreelancerHome extends StatefulWidget {
  final AppUser user;
  const FreelancerHome({super.key, required this.user});

  @override
  State<FreelancerHome> createState() => _FreelancerHomeState();
}

class _FreelancerHomeState extends State<FreelancerHome> {
  int index = 0;
  final pages = [];

  @override
  void initState() {
    pages.addAll([
      const FreelancerDashboard(),
      const EditProfileScreen(),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work_outline), label: 'Jobs'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class FreelancerDashboard extends StatelessWidget {
  const FreelancerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('Available Jobs')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, i) => const JobCard(),
      ),
    );
  }
}
