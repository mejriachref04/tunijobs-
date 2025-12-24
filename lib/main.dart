import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tunijobs/screens/auth/login_screen.dart';
import 'package:tunijobs/screens/auth/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_job_screen.dart';
import 'screens/freelancer_dashboard_screen.dart';
import 'screens/client_dashboard_screen.dart';
import 'screens/job_details_screen.dart';
import 'screens/order_completion_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TuniJobsApp());
}

class TuniJobsApp extends StatelessWidget {
  const TuniJobsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuniJobs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/home': (_) => const HomeScreen(),
        '/postJob': (_) => const PostJobScreen(),
        '/freelancerDashboard': (_) => const FreelancerDashboardScreen(),
        '/clientDashboard': (_) => const ClientDashboardScreen(),
      },
    );
  }
}
