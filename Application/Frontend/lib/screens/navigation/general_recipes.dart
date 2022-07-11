import 'package:flutter/material.dart';
import 'package:recipedia/components/recipe/general_nutrient_recipes.dart';
import 'package:recipedia/constants.dart';

class GeneralRecipes extends StatefulWidget {
  const GeneralRecipes({Key? key}) : super(key: key);

  @override
  State<GeneralRecipes> createState() => _GeneralRecipesState();
}

class _GeneralRecipesState extends State<GeneralRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: const [
        GeneralNutrientRecipes(
            title: 'Proteins',
            subtitle: 'Recipes rich with protein',
            url: '$serverUrl/protein-recipes'),
        GeneralNutrientRecipes(
            title: 'Carbohydrates',
            subtitle: 'Recipes which help you carboload',
            url: '$serverUrl/carbohydrates-recipes'),
        GeneralNutrientRecipes(
            title: 'Calories',
            subtitle: 'Recipes which have a good amount of calories',
            url: '$serverUrl/calories-recipes'),
        GeneralNutrientRecipes(
            title: 'Fat',
            subtitle: 'Recipes filled with a good amount of fat',
            url: '$serverUrl/fat-recipes'),
      ],
    )));
  }
}
