import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// Test comment
void main() {
  runApp(Student_benefits());
}

class Student_benefits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> funFacts = [
    "Fun Fact 1:Over one's lifetime , a person with a bachelor's degree stands to earn 1 milliom more than someone with a high school diploma",
    "Fun Fact 2: Studies show that college graduates report higher levels of personal satisfaction and well-being compared to non-graduates.",
    "Fun Fact 3: Colleges offer libraries, research facilities, career centers, and other resources that can enhance your learning and development.",
    // Add more fun facts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Your benefits",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          OptionCard("Scholarships", "Tagline for Option 2"),
          SizedBox(height: 10),
          OptionCard("Work-Study", "Tagline for Option 3"),
          SizedBox(height: 10),
          OptionCard("Emergency Funding", "Tagline for Option 4"),
          SizedBox(height: 10),
          OptionCard("Housing benefits", "Tagline for Option 5"),
          SizedBox(height: 8),
          FunFactBanner(funFacts),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String optionText;
  final String tagline;

  OptionCard(this.optionText, this.tagline);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        color: Colors.lightBlue, // Light pink color
        child: ListTile(
          title: Text(
            optionText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(tagline),
          onTap: () {
            print("Selected: $optionText");
          },
        ),
      ),
    );
  }
}

class FunFactBanner extends StatelessWidget {
  final List<String> funFacts;

  FunFactBanner(this.funFacts);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: funFacts.map((fact) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            color: Colors.pink[100], // Light pink color
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    fact,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Learn more button pressed for: $fact");
                    // Add your Learn more button logic here
                  },
                  child: Text("Learn more"),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0, // Each card takes the complete width of the screen
      ),
    );
  }
}
