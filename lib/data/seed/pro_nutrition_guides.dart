/// Curated external nutrition education links (open in browser).
/// Not medical advice — attribution only; we do not republish full articles.
class ProNutritionGuide {
  const ProNutritionGuide({
    required this.id,
    required this.title,
    required this.source,
    required this.benefit,
    required this.url,
  });

  final String id;
  final String title;
  final String source;
  final String benefit;
  final String url;
}

/// Short shopping / label pointers from Food Pharmer’s Better for You rules.
/// Opens their category or criteria pages — we don’t republish brand lists.
class FoodPharmerPointer {
  const FoodPharmerPointer({
    required this.id,
    required this.title,
    required this.tip,
    required this.url,
  });

  final String id;
  final String title;
  final String tip;
  final String url;
}

const proNutritionGuides = <ProNutritionGuide>[
  ProNutritionGuide(
    id: 'foodpharmer_better',
    title: 'Better for You packaged picks',
    source: 'Food Pharmer',
    benefit:
        'India-focused, expert-reviewed categories — yoghurt, paneer, oats, and more.',
    url: 'https://foodpharmer.health/',
  ),
  ProNutritionGuide(
    id: 'foodpharmer_criteria',
    title: 'Label rules by category',
    source: 'Food Pharmer',
    benefit:
        'Protein floors, sugar caps, no-maida / no-starch checks before you buy.',
    url: 'https://foodpharmer.health/criteria',
  ),
  ProNutritionGuide(
    id: 'acsm_fueling',
    title: 'Fueling for exercise',
    source: 'ACSM',
    benefit: 'Clear pre- and post-workout timing so energy and recovery line up.',
    url: 'https://www.acsm.org/education-resources/trending-topics-resources/resource-library',
  ),
  ProNutritionGuide(
    id: 'eatright_protein',
    title: 'Protein for recovery',
    source: 'Academy of Nutrition and Dietetics',
    benefit: 'How much protein helps rebuild after training — practical ranges.',
    url: 'https://www.eatright.org/fitness/physical-activity/eating-before-or-after-activity',
  ),
  ProNutritionGuide(
    id: 'nhs_balanced',
    title: 'Balanced plates, every day',
    source: 'NHS Eatwell',
    benefit: 'Simple plate model for carbs, protein, and veg around gym days.',
    url: 'https://www.nhs.uk/live-well/eat-well/food-guidelines-and-food-labels/the-eatwell-guide/',
  ),
  ProNutritionGuide(
    id: 'nin_india',
    title: 'India dietary guidance',
    source: 'ICMR–NIN',
    benefit: 'Portion and food-group guidance relevant to Indian kitchens.',
    url: 'https://www.nin.res.in/',
  ),
  ProNutritionGuide(
    id: 'iimr_millets',
    title: 'Millet nutrition tables',
    source: 'IIMR',
    benefit: 'Finger millet (ragi) calcium/iron protein benchmarks used in our meal notes.',
    url: 'https://millets.res.in/millets_info.php',
  ),
];

/// Gym-relevant Food Pharmer category tips for the Nutrition tab.
const foodPharmerPointers = <FoodPharmerPointer>[
  FoodPharmerPointer(
    id: 'fp_yogurt',
    title: 'High-protein yoghurt',
    tip: 'Aim for ≥10g protein / 100g · no added sugar · no artificial flavours.',
    url: 'https://foodpharmer.health/c/yogurt',
  ),
  FoodPharmerPointer(
    id: 'fp_paneer',
    title: 'Clean paneer',
    tip: 'Prefer lab-tested picks with no vegetable oil and no starch fillers.',
    url: 'https://foodpharmer.health/c/paneer',
  ),
  FoodPharmerPointer(
    id: 'fp_paneer_hp',
    title: 'High-protein paneer',
    tip: 'Their HP bar: ≥25g protein / 100g and under 10g fat / 100g.',
    url: 'https://foodpharmer.health/c/paneer-high-protein',
  ),
  FoodPharmerPointer(
    id: 'fp_oats',
    title: 'High-protein oats',
    tip: 'Look for >25g protein / 100g and under 20g total sugar / 100g.',
    url: 'https://foodpharmer.health/c/oats-high-protein',
  ),
  FoodPharmerPointer(
    id: 'fp_pb',
    title: 'Peanut butter',
    tip: '100% peanuts (or peanuts + whey) · no sugar · no hydrogenated oils.',
    url: 'https://foodpharmer.health/c/peanut-butter',
  ),
  FoodPharmerPointer(
    id: 'fp_tofu',
    title: 'Tofu',
    tip: 'Plant protein staple — check their reviewed tofu list before buying.',
    url: 'https://foodpharmer.health/c/tofu',
  ),
  FoodPharmerPointer(
    id: 'fp_tempeh',
    title: 'Tempeh',
    tip: 'Fermented soy option for higher protein plant meals.',
    url: 'https://foodpharmer.health/c/tempeh',
  ),
  FoodPharmerPointer(
    id: 'fp_makhana',
    title: 'Makhana',
    tip: 'Snack rule of thumb from their board: only 100% makhana.',
    url: 'https://foodpharmer.health/c/makhana',
  ),
  FoodPharmerPointer(
    id: 'fp_criteria',
    title: 'Full criteria',
    tip: 'Every category has its own pass/fail rules — skim before you shop.',
    url: 'https://foodpharmer.health/criteria',
  ),
];
