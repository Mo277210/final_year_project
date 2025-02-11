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
          // Sidebar with filter options
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
                    color: selectedIndex == index
                        ? Colors.blue[100]
                        : Colors.transparent,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      filterCategories[index],
                      style: TextStyle(
                        color:
                        selectedIndex == index ? Colors.blue : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Filter Options Panel
          Expanded(
            child: FilterOptions(title: filterCategories[selectedIndex]),
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
  List<String> selectedCheckboxValues = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> options = getFilterOptions(widget.title);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select ${widget.title}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...options,
        ],
      ),
    );
  }

  List<Widget> getFilterOptions(String category) {
    switch (category) {
      case "Distance":
        return [
          radioTile("Within 1 km"),
          radioTile("Within 5 km"),
          radioTile("Within 10 km"),
          radioTile("Beyond 10 km"),
        ];

      case "Gender":
        return [
          radioTile("Male Doctors"),
          radioTile("Female Doctors"),
          radioTile("Any Gender"),
        ];

      case "Patient Stories":
        return [
          radioTile("Highly Recommended"),
          radioTile("Good Experience"),
          radioTile("Neutral"),
          radioTile("Needs Improvement"),
        ];

      case "Experience":
        return [
          radioTile("5+ Years"),
          radioTile("10+ Years"),
          radioTile("20+ Years"),
          radioTile("30+ Years"),
        ];

      case "Consultation Fee":
        return [
          radioTile("Free Consultation"),
          radioTile("₹100 - ₹500"),
          radioTile("₹500 - ₹1000"),
          radioTile("₹1000+"),
        ];

      case "Availability":
        return [
          checkboxTile("Today"),
          checkboxTile("Tomorrow"),
          checkboxTile("Weekend"),
          checkboxTile("Evening Slots"),
        ];

      default:
        return [const Text("No options available")];
    }
  }

  Widget radioTile(String text) {
    return ListTile(
      title: Text(text),
      trailing: Radio<String>(
        value: text,
        groupValue: selectedValue,
        activeColor: Colors.blue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
    );
  }

  Widget checkboxTile(String text) {
    return ListTile(
      title: Text(text),
      trailing: Checkbox(
        value: selectedCheckboxValues.contains(text),
        activeColor: Colors.blue,
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              selectedCheckboxValues.add(text);
            } else {
              selectedCheckboxValues.remove(text);
            }
          });
        },
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
