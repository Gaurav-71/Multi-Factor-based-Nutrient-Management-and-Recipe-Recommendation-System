import 'package:flutter/material.dart';
import 'package:recipedia/models/api_response.dart';

class Recipe extends StatefulWidget {
  final ApiResponse recipe;
  const Recipe({Key? key, required this.recipe}) : super(key: key);

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        CircleAvatar(
          backgroundColor: Colors.black87,
          radius: 32,
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.recipe.imageUrl.toString()),
            radius: 30,
          ),
        )
      ],
    );
  }
}
