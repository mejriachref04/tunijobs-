import 'package:flutter/material.dart';
import 'package:tunijobs/models/user_model.dart';
import 'package:tunijobs/screens/jobs/post_job_screen.dart';
import 'package:tunijobs/screens/profile/edit_profile_screen.dart';
import 'package:tunijobs/widgets/job_card.dart';

class ClientHome extends StatefulWidget {
  final AppUser user;
  const ClientHome({super.key, required this.user});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int index = 0;
  final pages = [];

  @override
  void initState() {
    pages.addAll([
      const ClientDashboard(),
      const PostJobScreen(),
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
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Post'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class ClientDashboard extends StatelessWidget {
  const ClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('TuniJobs – My Jobs')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (_, i) => const JobCard(),
      ),
    );
  }
}
