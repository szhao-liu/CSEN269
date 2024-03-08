import 'package:flutter/material.dart';

void main() {
  runApp(Student_testimonials());
}

class SuccessStory {
  final String name;
  final String photoPath;
  final double income;
  final String description;


  SuccessStory({
    required this.name,
    required this.photoPath,
    required this.income,
    required this.description,

  });
}

class Student_testimonials extends StatelessWidget {
  final List<SuccessStory> successStories = [
    SuccessStory(
      name: "John Doe",
      photoPath: "assets/stud1test.jpeg",
      income: 50000.0,
      description: "Focus on what you can control. The college application process can be stressful, and there are often aspects beyond your control. Concentrate on putting your best effort into your application, essays, and standardized tests if applicable.Share your goals and challenges with friends, family, or mentors who can offer encouragement and support. Having a reliable support system can help you stay motivated and navigate challenges more effectively.",

    ),
    SuccessStory(
      name: "Jane Smith",
      photoPath: "assets/testimonial_1.jpg",
      income: 75000.0,
      description: "College degree has been a game-changer for me. The flexibility of the framework allowed me to create innovative solutions, boosting my income significantly.",

    ),
    // Add more success stories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Success Stories'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: successStories.length,
          itemBuilder: (context, index) {
            return _buildCard(successStories[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCard(SuccessStory story) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            story.photoPath,
            fit: BoxFit.cover,
            height: 200.0, // Set a fixed height if needed
          ),
          ListTile(
            title: Text(story.name),
            subtitle: Text('Income: \$${story.income.toString()}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.description),
                SizedBox(height: 10),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
