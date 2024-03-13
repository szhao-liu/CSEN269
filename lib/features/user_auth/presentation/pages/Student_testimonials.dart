import 'package:flutter/material.dart';
import 'package:myapp/global/common/Header.dart' as CommonHeader;

void main() {
  runApp(Student_testimonials());
}

class SuccessStory {
  final String name;
  final String photoPath;
  final String description;

  SuccessStory({
    required this.name,
    required this.photoPath,
    required this.description,
  });
}

class Student_testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'MadimiOne',
        primaryColor: Colors.indigo,
      ),
      home: StudentTestimonials(),
    );
  }
}

class StudentTestimonials extends StatelessWidget {
  final List<SuccessStory> successStories = [
    SuccessStory(
      name: "John Doe",
      photoPath: "assets/student_1.jpeg",
      description:
      "\"Focus on what you can control. The college application process can be stressful, and there are often aspects beyond your control. Concentrate on putting your best effort into your application, essays, and standardized tests if applicable. Share your goals and challenges with friends, family, or mentors who can offer encouragement and support. Having a reliable support system can help you stay motivated and navigate challenges more effectively.\"",
    ),
    SuccessStory(
      name: "Jane Smith",
      photoPath: "assets/student_1.jpeg",
      description:
      "College degree has been a game-changer for me. The flexibility of the framework allowed me to create innovative solutions, boosting my income significantly.",
    ),
    // Add more success stories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/backgg.jpg',
            fit: BoxFit.cover,
          ),
          ListView.builder(
            itemCount: successStories.length,
            itemBuilder: (context, index) {
              return _buildCard(context, successStories[index]);
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CommonHeader.Header(dynamicText: "Meet the pioneers"),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, SuccessStory story) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 400.0, // Set a fixed height for the image section
              child: Image.asset(
                story.photoPath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center justify the text
                children: [
                  Text(
                    story.name,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                    textAlign: TextAlign.justify, // Center justify the text
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    story.description,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.indigo,
                    ),
                    textAlign: TextAlign.justify, // Center justify the text
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
