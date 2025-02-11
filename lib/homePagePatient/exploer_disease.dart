import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'information_nail.dart';

class ExploreDisease extends StatelessWidget {
  final int currentDiseaseIndex;
  final List<String> diseases;
  final List<String> diseaseImages;

  const ExploreDisease({
    required this.currentDiseaseIndex,
    required this.diseases,
    required this.diseaseImages,
    super.key,
  });

  static const List<String> causesList = [
    'The exact cause of Acral Lentiginous Melanoma (ALM) is not fully understood, but several factors may contribute to its development:\n\n'
        '- Genetic mutations affecting melanocytes in the skin\n'
        '- Chronic sun exposure (although ALM often occurs on sun-protected areas like the palms, soles, and under nails)\n'
        '- Repeated trauma to the affected area\n'
        '- Weakened immune system or immunosuppressive conditions\n'
        '- Family history of melanoma\n'
        '- Individuals with darker skin tones are more prone to developing ALM',
    'Blue Finger, or acrocyanosis, can be caused by:\n\n'
        '- Poor blood circulation leading to reduced oxygen in the extremities\n'
        '- Cold temperatures causing vasospasm (narrowing of blood vessels)\n'
        '- Raynaud’s disease, a condition causing intermittent blood flow restriction\n'
        '- Heart or lung diseases affecting oxygen delivery\n'
        '- Certain medications that cause blood vessel constriction\n'
        '- Blood clots or vascular disorders',
    'Beau’s Lines occur due to disruptions in nail growth and can be caused by:\n\n'
        '- Severe illness, high fever, or infections like COVID-19\n'
        '- Uncontrolled diabetes\n'
        '- Peripheral vascular disease (affecting blood flow to extremities)\n'
        '- Chemotherapy or other medications that impact cell growth\n'
        '- Trauma or injury to the nail matrix\n'
        '- Malnutrition, particularly deficiencies in zinc and protein',
    'Clubbing of the nails can be caused by:\n\n'
        '- Chronic lung diseases such as lung cancer or tuberculosis\n'
        '- Heart diseases like congenital heart defects and endocarditis\n'
        '- Liver diseases, particularly cirrhosis\n'
        '- Inflammatory bowel disease (Crohn’s disease, ulcerative colitis)\n'
        '- Cystic fibrosis, which affects the respiratory system\n'
        '- Hyperthyroidism (Graves’ disease)',
    'Koilonychia (Spoon Nails) is commonly linked to:\n\n'
        '- Iron deficiency anemia\n'
        '- Chronic exposure to detergents or chemicals\n'
        '- Frequent trauma or repetitive nail injuries\n'
        '- Autoimmune disorders such as lupus\n'
        '- Genetic factors (congenital koilonychia)\n'
        '- Hypothyroidism and other metabolic disorders',
    'Muehrcke’s Lines, which appear as white bands across the nails, can be caused by:\n\n'
        '- Low levels of albumin (a protein in the blood), often due to kidney or liver disease\n'
        '- Chemotherapy-induced nail changes\n'
        '- Malnutrition and protein deficiency\n'
        '- Nephrotic syndrome, a kidney disorder affecting protein balance\n'
        '- Chronic liver disease',
    'Pitting of the nails is often associated with:\n\n'
        '- Psoriasis, an autoimmune skin condition\n'
        '- Eczema (atopic dermatitis)\n'
        '- Alopecia areata (an autoimmune hair loss disorder)\n'
        '- Connective tissue diseases like lupus\n'
        '- Reiter’s syndrome (reactive arthritis)\n'
        '- Nail fungal infections',
    'Terry’s Nails, characterized by a white nail bed with a dark band at the tip, can be caused by:\n\n'
        '- Liver disease, especially cirrhosis\n'
        '- Chronic kidney failure\n'
        '- Heart failure affecting circulation\n'
        '- Uncontrolled diabetes\n'
        '- Aging-related nail changes\n'
        '- Malnutrition or severe illness',
  ];
  static const List<String> symptomsList = [
    'Symptoms of Acral Lentiginous Melanoma (ALM) include:\n\n'
        '- Dark brown or black streaks under the nails (subungual melanoma)\n'
        '- Irregular pigmentation on the palms, soles, or nail beds\n'
        '- A slowly expanding lesion that does not heal\n'
        '- A bruise-like mark that does not go away\n'
        '- Nail discoloration with potential nail separation\n'
        '- Ulceration, bleeding, or cracking in advanced cases\n'
        '- Pain or tenderness in the affected area',
    'Symptoms of Blue Finger (Acrocyanosis) include:\n\n'
        '- Bluish or purplish discoloration of fingers and toes\n'
        '- Cold, clammy skin\n'
        '- Numbness or tingling sensation\n'
        '- Worsening of symptoms in cold environments\n'
        '- Persistent discoloration without pain (differs from Raynaud’s disease)\n'
        '- Potential swelling in severe cases',
    'Symptoms of Beau’s Lines include:\n\n'
        '- Deep horizontal grooves or ridges across the nail\n'
        '- Lines appearing on multiple nails simultaneously\n'
        '- Growth disturbances causing nail deformity\n'
        '- Nail discoloration around the affected ridges\n'
        '- Thinning or thickening of the nail near the grooves\n'
        '- Temporary cessation of nail growth following illness or trauma',
    'Symptoms of Clubbing include:\n\n'
        '- Bulbous, swollen fingertips\n'
        '- Increased curvature of the nail, making it rounder\n'
        '- Softening of the nail bed\n'
        '- Loss of the normal angle between the nail and the cuticle\n'
        '- Enlargement of the fingertips\n'
        '- Increased shininess of nails and cuticles',
    'Symptoms of Koilonychia (Spoon Nails) include:\n\n'
        '- Thin, brittle nails that are concave or spoon-shaped\n'
        '- Nails that appear scooped out with raised edges\n'
        '- Slow nail growth\n'
        '- Increased nail fragility leading to cracking\n'
        '- Discoloration, including pale or white nails\n'
        '- Potential pain or discomfort in severe cases',
    'Symptoms of Muehrcke’s Lines include:\n\n'
        '- Paired, white, horizontal lines across multiple nails\n'
        '- Lines that do not move as the nail grows (unlike Beau’s Lines)\n'
        '- Absence of nail surface deformity\n'
        '- Association with low albumin levels (hypoalbuminemia)\n'
        '- Lines disappearing when pressure is applied to the nail bed\n'
        '- Affected nails typically remain smooth',
    'Symptoms of Pitting include:\n\n'
        '- Small dents or depressions on the nail surface\n'
        '- Irregular nail texture with rough patches\n'
        '- Brittle nails prone to crumbling\n'
        '- Discoloration, including yellow or white spots\n'
        '- Nails separating from the nail bed\n'
        '- Common in conditions like psoriasis and eczema',
    'Symptoms of Terry’s Nails include:\n\n'
        '- White discoloration covering most of the nail\n'
        '- A thin, reddish-brown band near the nail tip\n'
        '- Opaque, milk-white nails\n'
        '- Brittle nails that may split or crack\n'
        '- Associated with chronic liver or kidney disease\n'
        '- Affecting multiple nails symmetrically',
  ];
  static const List<String> treatmentList = [
    'Treatment for Acral Lentiginous Melanoma (ALM) depends on the stage and severity of the disease. Early detection and prompt medical intervention are crucial. Treatments may include:\n\n'
        '- Surgical removal of the affected tissue (wide local excision)\n'
        '- Sentinel lymph node biopsy if there is a risk of spread\n'
        '- Immunotherapy with drugs like pembrolizumab (Keytruda) or nivolumab\n'
        '- Targeted therapy for specific genetic mutations (BRAF inhibitors)\n'
        '- Radiation therapy in advanced or inoperable cases\n'
        '- Chemotherapy in cases where other treatments are ineffective',
    'Treatment for Blue Finger (Acrocyanosis) focuses on improving circulation and preventing symptoms. Common approaches include:\n\n'
        '- Keeping hands and feet warm with gloves and socks\n'
        '- Avoiding cold exposure and sudden temperature changes\n'
        '- Regular hand and foot exercises to improve blood flow\n'
        '- Medications like calcium channel blockers (nifedipine) in severe cases\n'
        '- Addressing underlying conditions such as Raynaud’s phenomenon',
    'Treatment for Beau’s Lines involves addressing the underlying cause, as the lines themselves will grow out over time. Possible interventions include:\n\n'
        '- Identifying and treating systemic illnesses (e.g., diabetes, infections)\n'
        '- Ensuring adequate nutrition, including biotin and essential vitamins\n'
        '- Avoiding repeated trauma to the nails\n'
        '- Using gentle nail care practices to prevent further damage\n'
        '- Regular monitoring of nail growth patterns',
    'Treatment for Clubbing focuses on managing the underlying health condition rather than the nails themselves. Approaches include:\n\n'
        '- Identifying and treating chronic lung or heart diseases\n'
        '- Managing conditions like liver disease, inflammatory bowel disease, or cancer\n'
        '- Oxygen therapy in cases of hypoxia-related clubbing\n'
        '- Surgical intervention in severe underlying conditions\n'
        '- Regular medical check-ups to monitor disease progression',
    'Treatment for Koilonychia (Spoon Nails) depends on the cause. Corrective measures include:\n\n'
        '- Iron supplementation in cases of iron-deficiency anemia\n'
        '- Avoiding prolonged exposure to harsh chemicals or detergents\n'
        '- Keeping nails trimmed and well-moisturized\n'
        '- Treating underlying conditions like hypothyroidism or autoimmune disorders\n'
        '- Ensuring a balanced diet with adequate iron, protein, and vitamin C',
    'Treatment for Muehrcke’s Lines primarily involves correcting the underlying protein deficiency. Possible treatments include:\n\n'
        '- Increasing albumin levels through a high-protein diet\n'
        '- Addressing chronic kidney or liver disease\n'
        '- Avoiding medications that may exacerbate hypoalbuminemia\n'
        '- Close monitoring of nutritional status and overall health\n'
        '- Regular medical follow-ups to track improvement',
    'Treatment for Pitting focuses on treating the underlying cause, such as psoriasis or eczema. Options include:\n\n'
        '- Topical corticosteroids or calcineurin inhibitors\n'
        '- Systemic treatments like methotrexate or biologics for severe cases\n'
        '- Moisturizing and protecting nails from trauma\n'
        '- Using nail hardeners or protective coatings\n'
        '- Light therapy (phototherapy) in resistant cases',
    'Treatment for Terry’s Nails depends on the underlying condition, as the nail changes are often a symptom of systemic diseases. Management strategies include:\n\n'
        '- Treating liver disease, diabetes, or heart failure\n'
        '- Monitoring and maintaining optimal blood circulation\n'
        '- Addressing malnutrition or vitamin deficiencies\n'
        '- Regular nail care to prevent infections\n'
        '- Consulting a healthcare provider for proper diagnosis and management',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text(
          'Nägel',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF105DFB),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    diseaseImages[currentDiseaseIndex],
                    height: 350,
                    width: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  diseases[currentDiseaseIndex],
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF105DFB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "causes",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF105DFB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  causesList[currentDiseaseIndex],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Symptoms",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF105DFB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  symptomsList[currentDiseaseIndex],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Treatment",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF105DFB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  treatmentList[currentDiseaseIndex],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InformationNail(),
    );
  }
}
