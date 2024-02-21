import 'package:flutter/material.dart';
import '../main.dart';

class Mcq extends StatefulWidget {
  const Mcq({Key? key}) : super(key: key);

  @override
  State<Mcq> createState() => _McqState();
}

class _McqState extends State<Mcq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF88AB8E),
      appBar: AppBar(
        backgroundColor: Color(0xFF88AB8E),
        title: Text('MCQ'),
      ),
      body: Test(),
    );
  }
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final noteStream = supabase.from('question').stream(primaryKey: ['id']);
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

  void _submitAnswers(List<Map<String, dynamic>> notes) {
    showScoreDialog(notes);
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

  void showScoreDialog(List<Map<String, dynamic>> notes) {
    int score = calculateScore(notes);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Your Score"),
          content: Text("You scored $score out of ${notes.length}"),
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

// class _TestState extends State<Test> {
//   final noteStream = supabase.from('question').stream(primaryKey: ['id']);
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double questionTextSize =
//         screenWidth * 0.05; // Adjust this factor according to your preference
//
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: StreamBuilder(
//         stream: noteStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//           final notes = snapshot.data!;
//           print(notes.length);
//           return ListView.builder(
//             itemCount: notes.length,
//             itemBuilder: (context, index) {
//               final note = notes[index];
//               List<Widget> optionsWidgets = [];
//               for (int i = 1; i <= 4; i++) {
//                 optionsWidgets.add(
//                   RadioListTile(
//                     title: Text(note['option_$i']),
//                     value: i,
//                     groupValue: note['answer'] != null
//                         ? int.tryParse(note['answer'])
//                         : null,
//                     onChanged: (value) {
//                       setState(() {
//                         note['answer'] = value.toString();
//                       });
//                     },
//                   ),
//                 );
//               }
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Question ${index + 1}: ${note['question_title']}",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: questionTextSize),
//                   ),
//                   SizedBox(height: 10),
//                   Column(
//                     children: optionsWidgets,
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
