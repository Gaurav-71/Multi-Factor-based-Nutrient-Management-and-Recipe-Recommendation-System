import 'dart:ffi';

class FirebaseResponse {
  final String? nickel;
  final String? zinc;
  final String? niacin;
  final String? vitaminB6;
  final String? vitaminB7;
  final String? vitaminB9;
  final List<dynamic>? skipIngredients;
  final String? protein;
  final String? manganese;
  final String? magnesium;
  final String? carbohydrates;
  final String? thiamine;
  final String? gender;
  final String? ageRange;
  final String? energy;
  final String? fat;
  final String? ash;
  final String? pantac;
  final String? dietaryFibre;
  final String? uid;
  final String? iron;
  final String? riboflavin;
  final String? phosphor;
  final String? potassium;
  final String? vitaminC;
  final String? calcium;
  final String? aluminium;
  final String? sodium;
  final String? copper;

  FirebaseResponse(
      this.nickel,
      this.zinc,
      this.niacin,
      this.vitaminB6,
      this.vitaminB7,
      this.vitaminB9,
      this.skipIngredients,
      this.protein,
      this.manganese,
      this.magnesium,
      this.carbohydrates,
      this.thiamine,
      this.gender,
      this.ageRange,
      this.energy,
      this.fat,
      this.ash,
      this.pantac,
      this.dietaryFibre,
      this.uid,
      this.iron,
      this.riboflavin,
      this.phosphor,
      this.potassium,
      this.vitaminC,
      this.calcium,
      this.aluminium,
      this.sodium,
      this.copper);

  factory FirebaseResponse.fromJson(Map<String, dynamic>? json) {
    return FirebaseResponse(
      json?['Nickel'] as String?,
      json?['Zinc'] as String?,
      json?['Niacin'] as String?,
      json?['Vitamin B6'] as String?,
      json?['Vitamin B7'] as String?,
      json?['Vitamin B9'] as String?,
      json?['skipIngredients'] as List<dynamic>,
      json?['Protein'] as String?,
      json?['Manganese'] as String?,
      json?['Magnesium'] as String?,
      json?['Carbohydrates'] as String?,
      json?['Thiamine'] as String?,
      json?['Gender'] as String?,
      json?['Age Range'] as String?,
      json?['Energy'] as String?,
      json?['Fat'] as String?,
      json?['Ash'] as String?,
      json?['Pantac'] as String?,
      json?['Dietary Fibre'] as String?,
      json?['uid'] as String?,
      json?['Iron'] as String?,
      json?['Riboflavin'] as String?,
      json?['Phosphor'] as String?,
      json?['Potassium'] as String?,
      json?['Vitamin C'] as String?,
      json?['Calcium'] as String?,
      json?['Aluminium'] as String?,
      json?['Sodium'] as String?,
      json?['Copper'] as String?,
    );
  }
}
