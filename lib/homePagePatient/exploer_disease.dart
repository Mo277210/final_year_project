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
                    fontSize: 30,
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
                    fontSize: 28,
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
