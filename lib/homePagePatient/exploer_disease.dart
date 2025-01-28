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
    'While little information is known about the cause of onychoschizia, it is commonly linked to the following conditions:\n\n'
        '- Repeated wetting and drying of the fingernails\n'
        '- Excessive immersion in water with detergents\n'
        '- Recurrent application of nail polish\n'
        '- Frequent use of solvents to remove nail polish\n'
        '- Old age\n'
        '- Systemic (body-wide) diseases\n'
        '- Certain drugs\n'
        '- Nutritional deficiencies in iron, zinc, and selenium\n'
        '- Polycythemia, which is a blood disorder that causes too many red blood cells',

    'While the exact cause of onychogryphosis is not known, it can be triggered by:\n\n'
        '- Trauma such as burn injuries or other nail injuries\n'
        '- Ichthyosis: a group of skin disorders that causes dry, scaly, or thick skin\n'
        '- Nail psoriasis\n'
        '- Nail bed deformities\n'
        '- Bony deformities like hallux valgus (bunion)\n'
        '- Nail fungal infections (onychomycosis)\n'
        '- Long-standing poor personal care or neglect\n'
        '- Impairment of peripheral circulation, such as varicose veins\n'
        '- Improperly fitting shoes or footgear',

    'Causes of onycholysis can include:\n\n'
        '- Nail fungal infection\n'
        '- Nail psoriasis\n'
        '- Allergic contact dermatitis\n'
        '- Pseudomonas: A bacterial infection common in people who frequently have their hands in water\n'
        '- Long fingernails that act as a lever to pull the nail away from your skin\n'
        '- Trauma or injury',
  ];
  static const List<String> symptomsList = [
    'Symptoms of nail psoriasis include:\n\n'
        '- Pitting: Deep or shallow lines, ridges, dents, or dots in your nail\n'
        '- Deformation: Changes in the normal nail shape\n'
        '- Leukonychia: White spots within your nail plate\n'
        '- Thickening of the nail: There will also be build-up under your nail\n'
        '- Thinning and crumbling of the nail\n'
        '- Onycholysis: Separation of the nail from the nail bed\n'
        '- White, brown, or yellow discoloration\n'
        '- Blood under your nail',

    'Onychoschizia causes horizontal splitting of the nail plates with symptoms such as:\n\n'
        '- Nails that split, flake, and crumble\n'
        '- Nails that become soft and lose elasticity\n'
        '- Longitudinal splitting\n'
        '- Shallow parallel furrows running on the superficial layer of the nail\n'
        '- Superficial granulation of keratin appearing as dry, white areas\n'
        '- Worn-down nails\n'
        '- Significant cosmetic and functional problems in performing daily or occupational activities\n'
        '- Pain from deep nail splitting and the nail catching on to things',

    'Onycholysis symptoms include:\n\n'
        '- Distal onycholysis: Nail plate separation begins at the far edge of the nail and proceeds down toward the cuticle (most common)\n'
        '- Proximal onycholysis: Nail plate separation starts in the cuticle area and continues up the nail\n'
        '- The disease often causes substantial distress, affecting your quality of life and causing significant physical and occupational limitations.',
  ];
  static const List<String> treatmentList = [
    'Contact your healthcare provider if you have psoriasis and notice changes on your fingernails. Keeping your nails short and protecting them from damage can help prevent the condition from worsening.\n\n'
        'Treatment involves prescribed therapies, though achieving results is a slow process. Treatments for nail psoriasis include:\n\n'
        '- Corticosteroid injections into, under, or near the nail\n'
        '- Systemic therapies, like disease-modifying anti-rheumatic drugs (DMARDs), Otrexup, Rasuvo, and others (methotrexate), Sandimmune (cyclosporine), Otezla (apremilast), Biologics, and Humira (adalimumab), Cosentyx (secukinumab)',

    'Brittle-splitting nails that occur secondary to a body-wide problem should involve treating the primary dermatological or systemic condition. Cure of the brittle nails typically requires the following strategies:\n\n'
        '- Limit contact with water and detergents\n'
        '- Regular use of emollients on the nail\n'
        'The following treatments may also be effective:\n\n'
        '- Oral supplementation with biotin (a water-soluble vitamin)\n'
        '- Prolonged treatment with zinc in cases of zinc deficiency\n'
        '- Prolonged treatment with iron supplementation plus vitamin C\n'
        '- Nail moisturizers\n'
        '- Nail lacquers known as nail hardeners or nail strengtheners',

    'Onychomycosis is difficult to treat. The main goals of treatment include eradication of pathogens, restoration of healthy nails, and the prevention of recurrence. Based on your condition, your healthcare provider may use one of the following treatments:\n\n'
        '- Systemic therapies like Lamisil (terbinafine) and Sporonox (itraconazole)\n'
        '- Topical antifungal therapies after removal of the unattached nail like Penlac, Loprox, Jublia (efinaconazole), and Kerydin (tavaborole)\n'
        '- Laser therapy',
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
