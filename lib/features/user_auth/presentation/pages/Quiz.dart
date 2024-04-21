import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MustKnowPage.dart';
import 'dart:ui';
import 'package:myapp/global/common/Header.dart' as CommonHeader;

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({
    Key? key,
    required this.theWidth,
    required this.theHeight,
    required this.theChild,
  }) : super(key: key);

  final double theWidth;
  final double theHeight;
  final Widget theChild;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: theWidth,
        height: theHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.13)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4.0,
            sigmaY: 4.0,
          ),
          child: Container(
            color: Colors.transparent,
            child: theChild,
          ),
        ),
      ),
    );
  }
}

class Quiz extends StatefulWidget {
  final String grade;

  Quiz({required this.grade});

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  Map<int, String> selectedOptions = {};
  bool isOptionSelected = false;

  @override
  void initState() {
    super.initState();
    fetchQuestionsForGrade();
  }

  Future<void> fetchQuestionsForGrade() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await FirebaseFirestore.instance.collection('Quiz').doc(widget.grade).get();

    if (documentSnapshot.exists) {
      if (documentSnapshot.data()!.containsKey('questions')) {
        List<dynamic> questionsList = documentSnapshot.data()!['questions'];

        for (var questionData in questionsList) {
          if (questionData is Map<String, dynamic>) {
            questions.add({
              'qtext': questionData['qtext'],
              'options': List<String>.from(questionData['options'] ?? []),
            });
          }
        }

        setState(() {});
      }
    }
  }

  void answerQuestion(String selectedOption) {
    setState(() {
      selectedOptions[currentQuestionIndex] = selectedOption;
      isOptionSelected = selectedOption.isNotEmpty;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isOptionSelected = selectedOptions[currentQuestionIndex] != null;
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        isOptionSelected = selectedOptions[currentQuestionIndex] != null;
      });
    }
  }

  bool isLastQuestion() {
    return currentQuestionIndex == questions.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/backgg.jpg', // Replace with your image asset path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              CommonHeader.Header(dynamicText: 'Quiz for ${widget.grade}'),
              Expanded(
                child: currentQuestionIndex < questions.length
                    ? buildQuizBody()
                    : buildSubmitQuizButton(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuizBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 50, // Adjust the top position as needed
          left: 10,
          right: 10,
          child: FrostedGlassBox(
            theWidth: double.infinity,
            theHeight: MediaQuery.of(context).size.height * 0.6,
            theChild: buildQuestionCard(questions[currentQuestionIndex]),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: TextButton(
            onPressed: () {
              // Navigate to MustKnowPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MustKnowPage(),
                ),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.indigo[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Skip Quiz',
              style: TextStyle(color: Colors.white,fontFamily: 'MadimiOne',),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: goToPreviousQuestion,
                child: Text('Previous'),
              ),
              ElevatedButton(
                onPressed: isOptionSelected
                    ? (isLastQuestion()
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MustKnowPage(),
                    ),
                  );
                }
                    : goToNextQuestion)
                    : null,
                child: Text(isLastQuestion() ? 'Submit Quiz' : 'Next Question'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSubmitQuizButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to MustKnowPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MustKnowPage(),
            ),
          );
        },
        child: Text('Submit Quiz'),
      ),
    );
  }

  Widget buildQuestionCard(Map<String, dynamic> question) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['qtext'],
              style: TextStyle(
                fontSize: 20, // Increase the font size for the question text
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Increase the spacing between question and options
            buildOptions(question['options']),
          ],
        ),
      ),
    );
  }

  Widget buildOptions(List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ElevatedButton(
            onPressed: () {
              answerQuestion(option);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedOptions[currentQuestionIndex] == option
                  ? Colors.green // Change the color when the option is selected
                  : Colors.deepPurple[50],
            ),
            child: Container(
              width: double.infinity, // Make the button full-width
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16, // Set the font size for the options
                  color: selectedOptions[currentQuestionIndex] == option
                      ? Colors.white // Change the text color when the option is selected
                      : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
