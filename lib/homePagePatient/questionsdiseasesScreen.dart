import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedIndex = 0;

  final List<String> filterCategories = [
    'ALM',
    'Blue Finger',
    'Beau\'s Line',
    'Clubbing',
    'Koilonychia',
    'Muehrcke\'s Lines',
    'Pitting',
    'Terry\'s Nail'
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
      body: Column(
        children: [
          Expanded(
            child: Row(
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
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors.black,
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
  List<String> selectedCheckboxValues = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> options = getFilterOptions(widget.title);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select ${widget.title}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ...options,
              ],
            ),
          ),
        ),

        // Save Button with Validation
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedCheckboxValues.isEmpty) {
                  // Show error if nothing is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          "Please select at least one option before saving."),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Proceed with selecting a doctor
                  String specialty = getDoctorSpecialty(widget.title);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Doctor Selected"),
                      content: Text("Suggested Specialty: $specialty"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedCheckboxValues
                                  .clear(); // Clear selections
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Save & Select Doctor",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getFilterOptions(String category) {
    switch (category) {
      case "ALM":
        return [
          checkboxTile("Do you have dark spots under your nails?"),
          checkboxTile("Have you noticed any color changes in your nails?"),
          checkboxTile("Is there a family history of melanoma?"),
        ];
      case "Blue Finger":
        return [
          checkboxTile("Do your fingers often feel cold?"),
          checkboxTile("Do your nails turn blue when exposed to cold?"),
          checkboxTile("Do you have circulation problems?"),
        ];
      case "Beau's Line":
        return [
          checkboxTile("Have you noticed horizontal grooves on your nails?"),
          checkboxTile("Have you experienced severe malnutrition recently?"),
          checkboxTile("Do you have any chronic illnesses like diabetes?"),
        ];
      case "Clubbing":
        return [
          checkboxTile("Do your nails appear more curved than usual?"),
          checkboxTile("Do you have breathing or heart problems?"),
          checkboxTile("Have you been diagnosed with any chronic lung disease?"),
        ];
      case "Koilonychia":
        return [
          checkboxTile("Are your nails thin and spoon-shaped?"),
          checkboxTile("Do you have iron deficiency or anemia?"),
          checkboxTile("Have you noticed any discoloration in your nails?"),
        ];
      case "Muehrcke's Lines":
        return [
          checkboxTile("Do you have white horizontal lines on your nails?"),
          checkboxTile("Do you have kidney or liver disease?"),
          checkboxTile("Do you have low albumin levels in your blood?"),
        ];
      case "Pitting":
        return [
          checkboxTile("Do your nails have small pits or dents?"),
          checkboxTile("Do you have psoriasis or alopecia?"),
          checkboxTile("Are there any other changes in your skin or scalp?"),
        ];
      case "Terry's Nail":
        return [
          checkboxTile("Are your nails half white and half brown?"),
          checkboxTile("Do you have liver disease?"),
          checkboxTile("Do you have any other health issues like diabetes or kidney failure?"),

        ];
      default:
        return [const Text("No options available")];
    }
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

// Function to map conditions to doctor specialties
String getDoctorSpecialty(String condition) {
  switch (condition) {
    case "ALM":
      return "Dermatologist or Oncologist";
    case "Blue Finger":
      return "Cardiologist or Vascular Specialist";
    case "Beau's Line":
      return "General Physician or Endocrinologist";
    case "Clubbing":
      return "Pulmonologist or Cardiologist";
    case "Koilonychia":
      return "Hematologist or Nutritionist";
    case "Muehrcke's Lines":
      return "Nephrologist or Hepatologist";
    case "Pitting":
      return "Dermatologist (Psoriasis/Alopecia Specialist)";
    case "Terry's Nail":
      return "Hepatologist or Endocrinologist";
    default:
      return "General Physician";
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FilterPage(),
  ));
}



