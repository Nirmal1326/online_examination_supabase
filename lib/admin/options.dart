import 'package:flutter/material.dart';
import '../main.dart';

class Questions extends StatefulWidget {
  const Questions({super.key});

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _question = TextEditingController();
  final TextEditingController _option_1 = TextEditingController();
  final TextEditingController _option_2 = TextEditingController();
  final TextEditingController _option_3 = TextEditingController();
  final TextEditingController _option_4 = TextEditingController();
  final TextEditingController _answer = TextEditingController();

  List<String> subjects = ['Java', 'Python', 'JavaScript', 'Cpp',];
  String selectedSubject = 'Java';

  AddQuestion() async {
    try {
      setState(() {
        isLoading = true;
      });
      String tableName = selectedSubject.toLowerCase();
      await supabase.from(tableName).insert({
        'question_title': _question.text.trim(),
        'option_1': _option_1.text.trim(),
        'option_2': _option_2.text.trim(),
        'option_3': _option_3.text.trim(),
        'option_4': _option_4.text.trim(),
        'answer': _answer.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Question Uploaded Successfully !"),
          ),
        );
        _question.clear();
        _option_1.clear();
        _option_2.clear();
        _option_3.clear();
        _option_4.clear();
        _answer.clear();
      }
      if (!mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error uploading Question !"),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
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
                  DropdownButton<String>(
                    value: selectedSubject,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSubject = newValue!;
                      });
                    },
                    items: subjects.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
                    child: TextFormField(
                      controller: _question,
                      decoration: InputDecoration(
                        labelText: 'Question',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _option_1,
                      decoration: InputDecoration(
                        labelText: 'Option 1',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _option_2,
                      decoration: InputDecoration(
                        labelText: 'Option 2',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _option_3,
                      decoration: InputDecoration(
                        labelText: 'Option 3',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _option_4,
                      decoration: InputDecoration(
                        labelText: 'Option 4',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                    child: TextFormField(
                      controller: _answer,
                      keyboardType: TextInputType.number,
                      decoration:
                      InputDecoration(labelText: 'Enter Answer number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required.';
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
                          AddQuestion();
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
                        'Upload',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
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
