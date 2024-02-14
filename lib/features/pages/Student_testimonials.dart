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
      photoPath: "assets/testimonial_1.jpg",
      income: 50000.0,
      description: "Thanks to my hard work and dedication, I've achieved financial success beyond my dreams. College degree made it easy to showcase my journey.",

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
