import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedIndex = 0;

  final List<String> filterCategories = [
    "Distance",
    "Gender",
    "Patient Stories",
    "Experience",
    "Consultation Fee",
    "Availability"
  ];

  final List<Widget> filterPages = [
    FilterOptions(title: "Distance"),
    FilterOptions(title: "Gender"),
    FilterOptions(title: "Patient Stories"),
    FilterOptions(title: "Experience"),
    FilterOptions(title: "Consultation Fee"),
    FilterOptions(title: "Availability"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter by',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Row(
        children: [
          Container(
            color: Colors.grey[100],
            width: 140,
            child: ListView.builder(
              itemCount: filterCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    color: selectedIndex == index ? Colors.blue[100] : Colors.transparent,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      filterCategories[index],
                      style: TextStyle(
                        color: selectedIndex == index ? Colors.blue : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Filter Options
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: filterPages,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterOptions extends StatefulWidget {
  final String title;

  const FilterOptions({Key? key, required this.title}) : super(key: key);

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('5+ Years'),
            trailing: Radio<String>(
              value: '5+ Years',
              groupValue: selectedValue,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('10+ Years'),
            trailing: Radio<String>(
              value: '10+ Years',
              groupValue: selectedValue,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('20+ Years'),
            trailing: Radio<String>(
              value: '20+ Years',
              groupValue: selectedValue,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('30+ Years'),
            trailing: Radio<String>(
              value: '30+ Years',
              groupValue: selectedValue,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FilterPage(),
  ));
}
