import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../user/home.dart';
import '../main.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured1 = true;
  bool _isObscured2 = true;
  bool isLoading = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _roll_num = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? temp;

  signup() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Ensure that the values are not empty
      String email = _email.text.trim();
      String password = _password.text.trim();
      String username = _username.text.trim();
      String rollNum = _roll_num.text.trim();
      // Perform user signup
      await supabase.auth
          .signUp(password: password, email: email)
          .then((value) async {
        // Insert student details into the database
        await supabase
            .from('student_details')
            .insert({'email': email, 'name': username, 'roll_num': rollNum});
      });
      // Navigate to home on successful signup
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } on AuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      if ('Signup requires a valid password' == e.message) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signup requires a valid password"),
          ),
        );
      }
      if ('User already registered' == e.message) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User already registered"),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during signup: $e");
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
                    'SIGN-UP',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Color(0xFFEEE7DA),
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
                    child: TextFormField(
                      controller: _username,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'User name is required.';
                        }
                        if (value.length < 3) {
                          return 'Please enter a Name with at least 3 characters';
                        }
                        if (value.length >= 20) {
                          return 'Please enter a Name with maximum of 20 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
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
                      controller: _roll_num,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers_outlined),
                        border: OutlineInputBorder(),
                        labelText: 'Roll Num',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Roll num is required.';
                        }
                        if (value.length < 6) {
                          return 'Please enter a Roll num with at least 6 characters';
                        }
                        if (value.length > 20) {
                          return 'Please enter a Roll num with maximum of 20 characters';
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
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      obscureText: _isObscured2,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(),
                        labelText: 'Re-Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscured2 = !_isObscured2;
                            });
                          },
                          icon: Icon(
                            _isObscured2
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required.';
                        }
                        if (temp != value) {
                          return 'Password not matching.';
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
                          signup();
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
                              'Sign-up',
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
                          'If you already have an account ?',
                          style: TextStyle(
                              fontSize: 17.0, color: Color(0xFF092635)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: const Text(
                            'Log-in',
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
