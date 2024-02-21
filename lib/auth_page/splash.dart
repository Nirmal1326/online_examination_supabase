import 'package:flutter/material.dart';
import 'package:online_examination_supabase/admin/dashboard.dart';
import 'package:online_examination_supabase/main.dart';
import '../user/home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }
    final session = supabase.auth.currentSession;
    final user = await supabase.auth.currentUser;
    if (session != null && user?.email != 'admin@gmail.com') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else if (user?.email == 'admin@gmail.com') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/Login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
