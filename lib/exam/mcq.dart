import 'package:flutter/material.dart';
import '../main.dart';

class Mcq extends StatefulWidget {
  const Mcq({Key? key}) : super(key: key);

  @override
  State<Mcq> createState() => _McqState();
}

class _McqState extends State<Mcq> {
  late String selectedSubject = 'Java'; // Default selected subject
  final List<String> subjects = ['Java', 'Python', 'JavaScript', 'Cpp'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF88AB8E),
      appBar: AppBar(
        backgroundColor: Color(0xFF88AB8E),
        title: Text('MCQ'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedSubject,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedSubject = newValue;
                });
              }
            },
            items: subjects.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: Test(selectedSubject: selectedSubject),
          ),
        ],
      ),
    );
  }
}

class Test extends StatefulWidget {
  final String selectedSubject;

  const Test({Key? key, required this.selectedSubject}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late Stream<List<Map<String, dynamic>>> noteStream;

  @override
  void initState() {
    super.initState();
    noteStream = _getNoteStream(widget.selectedSubject);
  }

  @override
  void didUpdateWidget(covariant Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSubject != oldWidget.selectedSubject) {
      setState(() {
        noteStream = _getNoteStream(widget.selectedSubject);
      });
    }
  }

  Stream<List<Map<String, dynamic>>> _getNoteStream(String selectedSubject) {
    return supabase
        .from(selectedSubject.toLowerCase())
        .stream(primaryKey: ['id']);
  }

  Map<String, String?> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: noteStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data as List<Map<String, dynamic>>;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    List<Widget> optionsWidgets = [];
                    final questionId = note['id'].toString();
                    for (int i = 1; i <= 4; i++) {
                      optionsWidgets.add(
                        RadioListTile(
                          title: Text(note['option_$i']),
                          value: i.toString(),
                          groupValue: selectedAnswers[questionId],
                          onChanged: (value) {
                            setState(() {
                              selectedAnswers[questionId] = value.toString();
                            });
                          },
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Question ${index + 1}: ${note['question_title']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: optionsWidgets,
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _submitAnswers(notes);
                },
                child: Text("Submit Answers"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submitAnswers(List<Map<String, dynamic>> notes) async {
    int score = calculateScore(notes);
    await updateScore(score);
    showScoreDialog(score, notes.length);
  }

  int calculateScore(List<Map<String, dynamic>> notes) {
    int score = 0;
    for (var note in notes) {
      int correctAnswer = note['answer'];
      String questionId = note['id'].toString();
      String? selectedAnswer = selectedAnswers[questionId];
      if (selectedAnswer != null &&
          selectedAnswer.isNotEmpty &&
          int.tryParse(selectedAnswer) == correctAnswer) {
        score++;
      }
    }
    return score;
  }

  Future<void> updateScore(int score) async {
    try {
      final response = await supabase
          .from('answer')
          .insert({'subject': widget.selectedSubject, 'score': score});
      if (response.error != null) {
        throw Exception(response.error!.message);
      }
    } catch (e) {
      print('Error updating score: $e');
    }
  }

  void showScoreDialog(int score, int totalQuestions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Your Score"),
          content: Text("You scored $score out of $totalQuestions"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
