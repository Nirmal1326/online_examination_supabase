import 'package:flutter/material.dart';
import 'package:online_examination_supabase/auth_page/login.dart';
import 'package:online_examination_supabase/auth_page/register.dart';
import 'package:online_examination_supabase/auth_page/splash.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: '',
    anonKey:
        '',
  );
  runApp(const BaseApp());
}

final supabase = Supabase.instance.client;

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Examination',
      home: StartPage(),
      routes: <String, WidgetBuilder>{
        '/Login': (context) => Login(),
        '/Register': (context) => Signup(),
      },
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF789461), //0xff
        appBar: AppBar(
          backgroundColor: Color(0xFF50623A),
          title: const Center(
            child: Text(
              'Online Examination',
              style: TextStyle(
                  color: Color(0xFFDBE7C9),
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: AssetImage('images/start.png'),
              ),
            ),
            SizedBox(
              height: 80.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SlideAction(
                onSubmit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashPage(),
                    ),
                  );
                  return null;
                },
                elevation: 24,
                borderRadius: 16,
                outerColor: Color(0xFF294B29),
                innerColor: Color(0xFFDBE7C9),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
