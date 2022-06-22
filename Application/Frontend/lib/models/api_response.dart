class Nutrients {
  final String? calories;
  final String? fat;
  final String? saturatedFat;
  final String? carbohydrates;
  final String? sugar;
  final String? cholesterol;
  final String? sodium;
  final String? protein;
  final String? vitaminB3;
  final String? selenium;
  final String? vitaminB6;
  final String? phosphorus;
  final String? vitaminB5;
  final String? zinc;
  final String? vitaminB2;
  final String? potassium;
  final String? vitaminC;
  final String? magnesium;
  final String? iron;
  final String? vitaminK;
  final String? manganese;
  final String? vitaminB1;
  final String? vitaminB12;
  final String? vitaminA;
  final String? folate;
  final String? vitaminE;
  final String? copper;
  final String? fiber;
  final String? calcium;
  final String? vitaminD;

  Nutrients(
      this.calories,
      this.fat,
      this.saturatedFat,
      this.carbohydrates,
      this.sugar,
      this.cholesterol,
      this.sodium,
      this.protein,
      this.vitaminB3,
      this.selenium,
      this.vitaminB6,
      this.phosphorus,
      this.vitaminB5,
      this.zinc,
      this.vitaminB2,
      this.potassium,
      this.vitaminC,
      this.magnesium,
      this.iron,
      this.vitaminK,
      this.manganese,
      this.vitaminB1,
      this.vitaminB12,
      this.vitaminA,
      this.folate,
      this.vitaminE,
      this.copper,
      this.fiber,
      this.calcium,
      this.vitaminD);

  factory Nutrients.fromJson(dynamic json) {
    return Nutrients(
        json['Calories'] as String?,
        json['Fat'] as String?,
        json['Saturated Fat'] as String?,
        json['Carbohydrates'] as String?,
        json['Sugar'] as String?,
        json['Cholesterol'] as String?,
        json['Sodium'] as String?,
        json['Protein'] as String?,
        json['Vitamin B3'] as String?,
        json['Selenium'] as String?,
        json['Vitamin B6'] as String?,
        json['Phosphorus'] as String?,
        json['Vitamin B5'] as String?,
        json['Zinc'] as String?,
        json['Vitamin B2'] as String?,
        json['Potassium'] as String?,
        json['Vitamin C'] as String?,
        json['Magnesium'] as String?,
        json['Iron'] as String?,
        json['Vitamin K'] as String?,
        json['Manganese'] as String?,
        json['Vitamin B1'] as String?,
        json['Vitamin B12'] as String?,
        json['Vitamin A'] as String?,
        json['Folate'] as String?,
        json['Vitamin E'] as String?,
        json['Copper'] as String?,
        json['Fiber'] as String?,
        json['Calcium'] as String?,
        json['Vitamin D'] as String?);
  }
}

class Ingredients {
  final String? name;
  final String? imgUrl;

  Ingredients(this.name, this.imgUrl);

  factory Ingredients.fromJson(dynamic json) {
    return Ingredients(json['name'] as String?, json['imageUrl'] as String?);
  }
}

class ApiResponse {
  final int? id;
  final String? title;
  final String? imageUrl;
  final String? ingedients;
  final List<Ingredients>? ingredients;
  final String? summary;
  final String? instruction;
  final Nutrients? nutrition;
  final String? videoUrl;

  ApiResponse(
      this.id,
      this.title,
      this.imageUrl,
      this.ingedients,
      this.ingredients,
      this.summary,
      this.instruction,
      this.nutrition,
      this.videoUrl);

  factory ApiResponse.fromJson(dynamic json) {
    var ingredients = json['ingredients'] as List;
    return ApiResponse(
        json['id'] as int?,
        json['title'] as String?,
        json['imageUrl'] as String?,
        json['ingedients'] as String?,
        ingredients.map((e) => Ingredients.fromJson(e)).toList(),
        json['summary'] as String?,
        json['instruction'] as String?,
        Nutrients.fromJson(json["nutrition"]),
        json['videoUrl'] as String?);
  }

  @override
  String toString() {
    return '{$id,\n $title,\n $imageUrl,\n $ingedients,\n $summary,\n $instruction,\n}';
  }
}
