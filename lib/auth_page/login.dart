import 'package:flutter/material.dart';
import 'package:online_examination_supabase/admin/dashboard.dart';
import 'package:online_examination_supabase/auth_page/register.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../user/home.dart';
import '../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured1 = true;
  bool isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? temp;

  signin() async {
    try {
      setState(() {
        isLoading = true;
      });
      await supabase.auth.signInWithPassword(
        password: _password.text.trim(),
        email: _email.text.trim(),
      );
      if (!mounted) return;
      if (_email.text.trim() == 'admin@gmail.com') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } on AuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      if ('Invalid login credentials' == e.message) {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your email or password was wrong."),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF88AB8E),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SIGN-IN',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Color(0xFFEEE7DA),
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required.';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _password,
                      obscureText: _isObscured1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured1 = !_isObscured1;
                            });
                          },
                          icon: Icon(
                            _isObscured1
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        temp = value;
                        if (value!.isEmpty) {
                          return 'Password is required.';
                        }
                        if (value.length < 6) {
                          return 'Please enter a password with at least 6 characters';
                        }
                        if (value.length > 20) {
                          return 'Please enter a password with maximum of 20 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signin();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF1B4242)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        // add boxShadow property
                        shadowColor: MaterialStateProperty.all(Colors.black),
                        elevation: MaterialStateProperty.all(2),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.teal,
                            )
                          : const Text(
                              'Sign-in',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 0),
                    child: Row(
                      children: [
                        const Text(
                          'If you dont have an account ?',
                          style: TextStyle(
                              fontSize: 17.0, color: Color(0xFF092635)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 17.0, color: Color(0xFF092635)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
