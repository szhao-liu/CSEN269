import 'package:flutter/material.dart';

class CollegeSearch extends StatefulWidget {
  @override
  _CollegeSearchState createState() => _CollegeSearchState();
}

class _CollegeSearchState extends State<CollegeSearch> {
  // Add your logic for handling search and filters here
  String searchValue = '';
  List<String> selectedFilters = [];

  // Mock data for options
  List<String> majorOptions = ['Engineering', 'Business', 'Arts'];
  List<String> locationOptions = ['Location A', 'Location B', 'Location C'];
  List<String> tuitionOptions = ['Tuition 1', 'Tuition 2', 'Tuition 3'];
  List<String> deadlineOptions = ['Deadline 1', 'Deadline 2', 'Deadline 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College Search'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Colleges...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchValue = value;
                  });
                },
              ),
              SizedBox(height: 16),

              // Filters Section
              ElevatedButton(
                onPressed: () {
                  _showFiltersDialog(context);
                },
                child: Text('Sort by Filters'),
              ),
              SizedBox(height: 16),

              // College Sections
              Text(
                'Colleges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Add your college information widgets here
              // Example: CollegeWidget(name: 'Sample College', image: 'assets/college_image.jpg'),
              // Repeat the CollegeWidget for each college
              for (int i = 1; i <= 10; i++)
                CollegeWidget(
                  name: 'College $i',
                  image: 'assets/santa.png',
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filters'),
          content: Column(
            children: [
              FilterWidget(
                label: 'Major',
                options: majorOptions,
                onSelectionChanged: (selectedValue) {
                  setState(() {
                    selectedFilters.add('Major: $selectedValue');
                  });
                },
              ),
              FilterWidget(
                label: 'Location',
                options: locationOptions,
                onSelectionChanged: (selectedValue) {
                  setState(() {
                    selectedFilters.add('Location: $selectedValue');
                  });
                },
              ),
              FilterWidget(
                label: 'Tuition Fees',
                options: tuitionOptions,
                onSelectionChanged: (selectedValue) {
                  setState(() {
                    selectedFilters.add('Tuition Fees: $selectedValue');
                  });
                },
              ),
              FilterWidget(
                label: 'Deadline',
                options: deadlineOptions,
                onSelectionChanged: (selectedValue) {
                  setState(() {
                    selectedFilters.add('Deadline: $selectedValue');
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logic to apply filters
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}

class FilterWidget extends StatefulWidget {
  final String label;
  final List<String> options;
  final void Function(String)? onSelectionChanged;

  FilterWidget({
    required this.label,
    required this.options,
    this.onSelectionChanged,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedValue,
          items: widget.options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
              widget.onSelectionChanged?.call(value ?? '');
            });
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class CollegeWidget extends StatelessWidget {
  final String name;
  final String image;

  CollegeWidget({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              height: 100, // Adjust the height as needed
              width: 100, // Adjust the width as needed
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Handle apply button click
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
