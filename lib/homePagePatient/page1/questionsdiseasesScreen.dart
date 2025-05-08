import 'package:collogefinalpoject/%20%20provider/provider.dart';
import 'package:collogefinalpoject/api/patient_home/patient_info.dart';
import 'package:collogefinalpoject/model/patient_home/patient_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../homePagePatient.dart';

class FilterPage extends StatefulWidget {
  final String diagnosis;
  const FilterPage({Key? key, required this.diagnosis}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  int selectedIndex = 0;
  late Future<PatientInfo?> patientInfoFuture;

  final List<String> filterCategories = [
    'Acral Lentiginous Melanoma',
    'Blue Finger',
    'Beaus Line',
    'Clubbing',
    'Koilonychia',
    'Muehrckes Lines',
    'Pitting',
    'Terrys Nail'
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < filterCategories.length; i++) {
      if (filterCategories[i] == widget.diagnosis) {
        selectedIndex = i;
        break;
      }
    }

    // تحميل بيانات المريض من API
    patientInfoFuture = _loadPatientInfo();
  }

  Future<PatientInfo?> _loadPatientInfo() async {
    final token = Provider.of<TokenProvider>(context, listen: false).token;
    final service = PatientInfoApiService();
    final response = await service.getPatientInfo(token);
    return response?.data;
  }

  @override
  Widget build(BuildContext context) {
    String currentDiagnosis = filterCategories[selectedIndex];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Answer the following Questions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<PatientInfo?>(
        future: patientInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Check Your Internet '));
          } else {
            final patientInfo = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: Row(
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
                      Expanded(
                        child: FilterOptions(
                          diagnosis: currentDiagnosis,
                          patientInfo: patientInfo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


class FilterOptions extends StatefulWidget {
  final String diagnosis;
  final PatientInfo patientInfo;

  const FilterOptions({Key? key, required this.diagnosis,required this.patientInfo}) : super(key: key);

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  List<String> selectedCheckboxValues = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> options = getFilterOptions(widget.diagnosis);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " ${widget.diagnosis}", // Using diagnosis here
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ...options,
                ],
              ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Please select at least one option before saving."),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  String selectedQuestion = selectedCheckboxValues.first;
                  String specialty = getDoctorSpecialtyFromQuestion(selectedQuestion);

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Doctor Selected"),
                      content: Text("Suggested Specialty: $specialty"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedCheckboxValues.clear();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Homepagepatient()),
                            );
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
              child: const Text("Save & Select Doctor", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getFilterOptions(String diagnosis) {
    switch (diagnosis) {
      case "Acral Lentiginous Melanoma":
        return [
          checkboxTile("Have you noticed any dark spots or new moles on your skin?"),
          checkboxTile("Have you observed any asymmetry, irregular borders, or multiple colors in a mole or spot?"),
          checkboxTile("Has a mole or spot started to bleed or become itchy recently?"),
          checkboxTile("Do you have a family history of melanoma or other skin cancers?"),
          checkboxTile("Have you had significant exposure to sunlight or tanning beds?"),
          checkboxTile("Do you have a history of immune-suppressing conditions or treatments like chemotherapy?"),
          checkboxTile("Have you noticed any changes in the texture of your skin or moles?"),
          checkboxTile("Do you experience any unusual pain or tenderness in a mole or skin spot?"),
          checkboxTile("Has a mole or spot changed in size or shape over time?"),
          checkboxTile("Have you noticed any new or unusual growths on your palms, soles, or under your nails?"),
          checkboxTile("Do you have a history of skin conditions or conditions that affect your skin’s ability to heal?"),
          checkboxTile("Are there any moles or spots that have irregular or jagged edges?"),
          checkboxTile("Have you ever been diagnosed with atypical moles or dysplastic nevi?"),
          checkboxTile("Do you have a history of frequent sunburns, especially in childhood?"),
          checkboxTile("Have you ever noticed a mole or skin lesion that is painful or bothersome?"),
          checkboxTile("Do you wear sunscreen regularly or protect your skin from excessive sun exposure?"),
        ];
      case "Blue Finger":
        return [
          // Respiratory Issues
          checkboxTile("Do you experience shortness of breath?"),
          checkboxTile("Do you have sharp chest pain?"),
          checkboxTile("Do you suffer from a persistent cough with phlegm?"),
          checkboxTile("Do you feel a loss of appetite?"),
          checkboxTile("Do you experience persistent headaches?"),

          // Heart Conditions
          checkboxTile("Do you have a family history of heart disease?"),
          checkboxTile("Do you suffer from any chronic heart problems or diseases?"),
          checkboxTile("Do you experience rapid and irregular heartbeat?"),
          checkboxTile("Do you have severe shortness of breath even at rest?"),
          checkboxTile("Do you experience swelling in your legs or ankles?"),
          checkboxTile("Have you noticed excessive sweating for no reason?"),
          checkboxTile("Do you experience sudden fainting or dizziness?"),

          // Vascular Issues (Raynaud's Phenomenon)
          checkboxTile("Do you experience numbness or tingling in your fingers when exposed to cold?"),
          checkboxTile("Do your fingers feel extremely cold?"),
          checkboxTile("Have you noticed color changes in your fingers in three phases: white, then blue, then red?"),
          if (widget.patientInfo.age > 45)
            checkboxTile("Have you had any heart evaluations or tests (e.g., ECG, echocardiogram) due to age-related concerns?"),
          // Gender-based question
          if (widget.patientInfo.gender.toLowerCase() == 'female')
            checkboxTile("Are you currently pregnant or have you been pregnant in the last year?"),
        ];

      case "Beaus Line":
        return [
          checkboxTile("Have you noticed horizontal grooves or ridges across your nails?"),
          checkboxTile("Have you experienced any significant illness or infection recently?"),
          checkboxTile("Have you experienced any trauma or injury to your hands or nails?"),
          checkboxTile("Do you have any chronic conditions like diabetes, cardiovascular disease, or autoimmune disorders?"),
          checkboxTile("Have you been under significant physical or emotional stress recently?"),
          checkboxTile("Do you have a history of malnutrition or poor nutrition?"),
          checkboxTile("Are you taking any medications that may affect the absorption of essential nutrients?"),
          checkboxTile("Do you have a history of hypertension or high blood pressure?"),
          checkboxTile("Have you experienced frequent headaches, dizziness, or lightheadedness?"),
          checkboxTile("Do you have a history of diabetes or high cholesterol?"),
          checkboxTile("Do you experience chronic fatigue or unusual weakness?"),
          checkboxTile("Have you been diagnosed with thyroid disorders such as hypothyroidism or hyperthyroidism?"),
          checkboxTile("Do you experience unexplained changes in weight or energy levels?"),
          checkboxTile("Do you experience unexplained weight gain or loss?"),
          checkboxTile("Have you noticed changes in your skin, hair, or nails that could be linked to a thyroid condition?"),
          checkboxTile("Do you have a history of polycystic ovary syndrome (PCOS) or other hormonal imbalances?"),
        ];
      case "Clubbing":
        return [
          // General Symptoms
          checkboxTile("Have you noticed a long-term change in the shape of your nails?"),
          checkboxTile("Is the change affecting one hand or both hands?"),
          checkboxTile("Do you feel pain, swelling, or redness in your fingers or nails?"),
          checkboxTile("Are there any other accompanying symptoms like changes in nail texture?"),

          // Respiratory Diseases
          checkboxTile("Do you have a persistent cough or difficulty breathing?"),
          checkboxTile("Have you been diagnosed with chronic pneumonia, tuberculosis, lung cancer, or pulmonary fibrosis?"),

          // Heart Diseases
          checkboxTile("Have you been diagnosed with any heart disease?"),
          checkboxTile("Do you experience shortness of breath upon exertion or rest?"),
          checkboxTile("Have you ever been diagnosed with endocarditis or heart valve disease?"),

          // Digestive & Liver Diseases
          checkboxTile("Do you have chronic liver or intestinal diseases like cirrhosis or Crohn’s disease?"),
          checkboxTile("Do you experience recurrent abdominal pain or changes in bowel movements?"),
          checkboxTile("Have you experienced unexplained weight loss or poor appetite?"),
          checkboxTile("Do you suffer from chronic acid reflux or heartburn?"),
          checkboxTile("Have you been diagnosed with irritable bowel syndrome (IBS) or Crohn's disease?"),
          checkboxTile("Do you experience abdominal pain, bloating, or constipation?"),
          checkboxTile("Have you noticed changes in your bowel movements, such as diarrhea or blood in your stool?"),

          // Family History
          checkboxTile("Is there a family history of heart, lung, liver, or hereditary diseases?"),

          // Lifestyle
          checkboxTile("Do you smoke or use tobacco products?"),
          checkboxTile("Are you frequently exposed to environmental pollutants or chemicals?"),
        ];

      case "Koilonychia":
        return [
          // Occupational Exposure
          checkboxTile("Are you frequently exposed to chemicals at work that may affect your nails?"),

          // Nutritional Deficiency (Iron Deficiency)
          checkboxTile("Do you feel tired or fatigued even with minimal effort?"),
          checkboxTile("Do you experience persistent headaches?"),
          checkboxTile("Are you suffering from hair loss or thinning hair?"),
          checkboxTile("Do you feel dizzy or lightheaded, possibly to the point of fainting?"),
          checkboxTile("Do you have irregular or rapid heartbeats?"),
          checkboxTile("Do you have inflammation or ulcers in your tongue or mouth?"),

          // Digestive Issues
          checkboxTile("Do you suffer from chronic diarrhea?"),
          checkboxTile("Do you experience rectal bleeding?"),
          checkboxTile("Do you have frequent bloating or excessive gas?"),
          checkboxTile("Do you suffer from abdominal pain or cramps?"),
          checkboxTile("Do you experience nausea or vomiting?"),
          checkboxTile("Have you noticed unexplained weight loss?"),
          checkboxTile("Do you have skin rashes?"),
          checkboxTile("Do you often feel anxious or depressed?"),
          checkboxTile("Do you suffer from red or swollen eyes?"),

          // Immune & Sensory Issues
          checkboxTile("Do you have a weakened immune system?"),
          checkboxTile("Do your wounds take a long time to heal?"),
          checkboxTile("Do you experience a loss of appetite?"),
          checkboxTile("Have you noticed a reduced sense of taste or smell?"),
          checkboxTile("Do you have problems with concentration or memory?"),
          // Age + Gender-based condition
          if (widget.patientInfo.gender.toLowerCase() == 'female' &&
              widget.patientInfo.age >= 12)
            checkboxTile("Do you have heavy menstrual bleeding or anemia due to menstruation?"),
        ];

      case "Muehrckes Lines":
        return [
          checkboxTile("Have you noticed white horizontal bands across your nails?"),
          checkboxTile("Do you have kidney or liver disease, or have you had abnormal liver or kidney function tests recently?"),
          checkboxTile("Do you have low albumin levels in your blood?"),
          checkboxTile("Have you experienced chronic malnutrition or protein deficiency?"),
          checkboxTile("Are you underweight or have you lost significant weight unintentionally?"),
          checkboxTile("Are you experiencing swelling in your legs, face, or body?"),
          checkboxTile("Have you noticed fluid retention or difficulty urinating recently?"),
          checkboxTile("Do you have a family history of diabetes or thyroid disorders?"),
          checkboxTile("Do you experience unexplained weight gain or loss?"),
          checkboxTile("Have you noticed changes in your skin, hair, or nails that could be linked to a thyroid condition?"),
          checkboxTile("Do you have a history of polycystic ovary syndrome (PCOS) or other hormonal imbalances?"),
          checkboxTile("Do you experience frequent urination, especially at night?"),
          checkboxTile("Have you noticed any changes in the color or smell of your urine?"),
          checkboxTile("Do you experience swelling in your legs, ankles, or face?"),
          checkboxTile("Have you been diagnosed with kidney disease or kidney stones in the past?"),
        ];
      case "Pitting":
        return [
          checkboxTile("Do your nails have small pits or indentations?"),
          checkboxTile("Do you have psoriasis, alopecia, or any autoimmune skin conditions?"),
          checkboxTile("Have you noticed changes in your skin or scalp, such as rashes, scaly patches, or thinning hair?"),
          checkboxTile("Have you experienced changes in your nail thickness or separation from the nail bed?"),
          checkboxTile("Are you experiencing joint pain, swelling, or stiffness, especially in your fingers or toes?"),
          checkboxTile("Have you been diagnosed with psoriatic arthritis or any other autoimmune disorders?"),
          checkboxTile("Have you experienced any changes in your skin’s appearance like discoloration or thickening?"),
          checkboxTile("Are you dealing with emotional or physical stress that could be affecting your health?"),
          checkboxTile("Do you experience pain or stiffness in your joints, especially in the mornings?"),
          checkboxTile("Have you been diagnosed with rheumatoid arthritis or lupus?"),
          checkboxTile("Do you have a history of chronic joint inflammation or deformities?"),
          checkboxTile("Do you have a family history of autoimmune disorders like rheumatoid arthritis or lupus?"),
        ];
      case "Terrys Nail":
        return [
          // Liver Disease
          checkboxTile("Have you ever been diagnosed with any liver disease?"),
          checkboxTile("Do you experience yellowing of the skin or whites of the eyes?"),
          checkboxTile("Do you experience swelling in your abdomen or feet?"),
          checkboxTile("Have you noticed a change in the color of your urine (very dark) or stools (very light)?"),

          // Heart Disease
          checkboxTile("Do you have any chronic heart disease?"),
          checkboxTile("Do you feel short of breath with minimal exertion?"),
          checkboxTile("Do you experience swelling in your legs or ankles?"),
          checkboxTile("Do you feel pain or pressure in your chest area?"),

          // Diabetes
          checkboxTile("Have you been diagnosed with diabetes?"),
          checkboxTile("Do you experience constant thirst or frequent urination?"),
          checkboxTile("Have you noticed slow healing of wounds?"),
          checkboxTile("Do you experience numbness or tingling in your hands or feet?"),

          // Malnutrition
          checkboxTile("Have you recently lost significant weight for no apparent reason?"),
          checkboxTile("Do you experience general weakness or persistent fatigue?"),
          checkboxTile("Is your daily diet healthy?"),

          // Kidney Disease
          checkboxTile("Are you experiencing swelling in your face or body?"),
          checkboxTile("Have you noticed a change in the amount or color of your urine?"),
          checkboxTile("Have you ever been diagnosed with any kidney disease?"),

          // Family History
          checkboxTile("Is there a family history of liver, heart, kidney, or diabetes disease?"),
          if (widget.patientInfo.age > 50)
            checkboxTile("Have you experienced memory issues or confusion lately?"),
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

String getDoctorSpecialtyFromQuestion(String question) {
  // Normalize the input question
  String normalizedQuestion = question.trim().toLowerCase();

  // Cardiology
  if (normalizedQuestion == "do you have a family history of heart disease?".toLowerCase() ||
      normalizedQuestion == "do you suffer from any chronic heart problems or diseases?".toLowerCase() ||
      normalizedQuestion == "do you experience rapid and irregular heartbeat?".toLowerCase() ||
      normalizedQuestion == "do you experience severe shortness of breath even when resting?".toLowerCase() ||
      normalizedQuestion == "do you experience swelling in your legs or ankles?".toLowerCase() ||
      normalizedQuestion == "have you noticed excessive sweating for no reason?".toLowerCase() ||
      normalizedQuestion == "do you experience sudden fainting or dizziness?".toLowerCase() ||
      normalizedQuestion == "have you had any heart evaluations or tests (e.g., ecg, echocardiogram) due to age-related concerns?".toLowerCase()) {
    return "Cardiologist";
  }

  // Pulmonology
  if (normalizedQuestion == "do you have shortness of breath or severe chest pain?".toLowerCase() ||
      normalizedQuestion == "do you suffer from a persistent cough with phlegm?".toLowerCase()) {
    return "Pulmonologist";
  }

  // Dermatology / Oncology
  if (normalizedQuestion == "have you noticed any dark spots or new moles on your skin?".toLowerCase() ||
      normalizedQuestion == "have you observed any asymmetry, irregular borders, or multiple colors in a mole or spot?".toLowerCase() ||
      normalizedQuestion == "has a mole or spot started to bleed or become itchy recently?".toLowerCase() ||
      normalizedQuestion == "do you have a family history of melanoma or other skin cancers?".toLowerCase() ||
      normalizedQuestion == "have you had significant exposure to sunlight or tanning beds?".toLowerCase() ||
      normalizedQuestion == "do you have a history of immune-suppressing conditions or treatments like chemotherapy?".toLowerCase() ||
      normalizedQuestion == "have you noticed any changes in the texture of your skin or moles?".toLowerCase() ||
      normalizedQuestion == "do you experience any unusual pain or tenderness in a mole or skin spot?".toLowerCase() ||
      normalizedQuestion == "has a mole or spot changed in size or shape over time?".toLowerCase() ||
      normalizedQuestion == "have you noticed any new or unusual growths on your palms, soles, or under your nails?".toLowerCase() ||
      normalizedQuestion == "do you have a history of skin conditions or conditions that affect your skin’s ability to heal?".toLowerCase() ||
      normalizedQuestion == "are there any moles or spots that have irregular or jagged edges?".toLowerCase() ||
      normalizedQuestion == "have you ever been diagnosed with atypical moles or dysplastic nevi?".toLowerCase() ||
      normalizedQuestion == "do you have a history of frequent sunburns, especially in childhood?".toLowerCase() ||
      normalizedQuestion == "have you ever noticed a mole or skin lesion that is painful or bothersome?".toLowerCase() ||
      normalizedQuestion == "do you wear sunscreen regularly or protect your skin from excessive sun exposure?".toLowerCase()) {
    return "Dermatologist or Oncologist";
  }

  // Hematology / Nutrition
  if (normalizedQuestion == "do you have iron deficiency or anemia?".toLowerCase() ||
      normalizedQuestion == "have you noticed hair loss, weakness, or irregular heartbeat?".toLowerCase()) {
    return "Hematologist or Nutritionist";
  }

  // Hepatology / Nephrology
  if (normalizedQuestion == "do you have liver disease or any other health issues like diabetes or kidney failure?".toLowerCase() ||
      normalizedQuestion == "have you noticed any changes in the amount or color of your urine?".toLowerCase() ||
      normalizedQuestion == "are your nails half white and half brown?".toLowerCase() ||
      normalizedQuestion == "do you have a family history of liver or kidney disease?".toLowerCase() ||
      normalizedQuestion == "do you experience swelling in your face, arms, or body (edema)?".toLowerCase() ||
      normalizedQuestion == "have you noticed any unexplained weight gain or loss?".toLowerCase() ||
      normalizedQuestion == "do you have chronic shortness of breath or cough?".toLowerCase() ||
      normalizedQuestion == "are you experiencing changes in appetite or digestion?".toLowerCase() ||
      normalizedQuestion == "do you have a history of liver cirrhosis or hepatitis?".toLowerCase()) {
    return "Hepatologist or Nephrologist";
  }

  // Rheumatology / Immunology
  if (normalizedQuestion == "do you have psoriasis, alopecia, or any autoimmune skin conditions?".toLowerCase() ||
      normalizedQuestion == "have you been diagnosed with psoriatic arthritis or any other autoimmune disorders?".toLowerCase() ||
      normalizedQuestion == "do you experience pain or stiffness in your joints, especially in the mornings?".toLowerCase() ||
      normalizedQuestion == "have you been diagnosed with rheumatoid arthritis or lupus?".toLowerCase() ||
      normalizedQuestion == "do you have a history of chronic joint inflammation or deformities?".toLowerCase() ||
      normalizedQuestion == "do you have a family history of autoimmune disorders like rheumatoid arthritis or lupus?".toLowerCase()) {
    return "Rheumatologist or Immunologist";
  }

  // Vascular / Internal Medicine
  if (normalizedQuestion == "do you experience numbness or tingling in your fingers when exposed to cold?".toLowerCase() ||
      normalizedQuestion == "do your fingers feel extremely cold?".toLowerCase() ||
      normalizedQuestion == "have you noticed the color of your fingers changing in three stages: white, then blue, then red?".toLowerCase() ||
      normalizedQuestion == "do you experience pain or cramping in your legs after walking a short distance?".toLowerCase() ||
      normalizedQuestion == "have you noticed varicose veins or spider veins on your legs?".toLowerCase() ||
      normalizedQuestion == "do you have swelling or heaviness in your legs, especially after standing for long periods?".toLowerCase() ||
      normalizedQuestion == "do you have a family history of blood clots or deep vein thrombosis (dvt)?".toLowerCase()) {
    return "Vascular Specialist or Internal Medicine";
  }

  // Endocrinology
  if (normalizedQuestion == "do you have a history of thyroid disorders?".toLowerCase() ||
      normalizedQuestion == "do you have a history of polycystic ovary syndrome (pcos) or other hormonal imbalances?".toLowerCase()) {
    return "Endocrinologist";
  }
  // Gynecology / Endocrinology
  if (normalizedQuestion == "are you currently pregnant or have you been pregnant in the last year?".toLowerCase()) {
    return "Gynecologist or Endocrinologist";
  }

  // Gynecology / Hematology
  if (normalizedQuestion == "do you have heavy menstrual bleeding or anemia due to menstruation?".toLowerCase()) {
    return "Gynecologist or Hematologist";
  }

  // Neurology
  if (normalizedQuestion == "have you experienced memory issues or confusion lately?".toLowerCase()) {
    return "Neurologist";
  }


  return "General Physician";
}






