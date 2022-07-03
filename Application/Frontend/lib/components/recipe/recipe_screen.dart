import 'package:flutter/material.dart';
import 'package:recipedia/components/recipe/recipe_card.dart';
import 'package:recipedia/components/recipe/recipe_images_horizontal.dart';
import 'package:recipedia/models/api_response.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeScreen extends StatefulWidget {
  final List<ApiResponse>? recipes;
  const RecipeScreen({Key? key, required this.recipes}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              buildTextTitleVariation1("Recipes for you"),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              buildTextSubTitleVariation2("Healthy and nutritous food recipes"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 70,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.recipes!.length,
                itemBuilder: ((context, index) {
                  final recipe = widget.recipes![index];
                  return Recipe(recipe: recipe);
                })),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: widget.recipes!.length,
                itemBuilder: ((context, index) {
                  final recipe = widget.recipes![index];
                  return RecipeCard(recipe: recipe);
                })),
          )
        ],
      ),
    );
  }

  buildTextTitleVariation1(String text) {
    return Text(
      text,
      style: GoogleFonts.staatliches(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
          letterSpacing: 1.5),
    );
  }

  buildTextSubTitleVariation2(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
    );
  }
}
