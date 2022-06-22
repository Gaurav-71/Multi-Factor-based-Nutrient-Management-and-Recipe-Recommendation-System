import 'package:flutter/material.dart';
import 'package:recipedia/components/recipe/nutrition_stat.dart';
import 'package:recipedia/components/recipe/video_screen.dart';
import 'package:recipedia/models/api_response.dart';

class RecipeCard extends StatefulWidget {
  final ApiResponse recipe;
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoScreen(recipe: widget.recipe)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: const BoxDecoration(
              color: Color.fromARGB(96, 239, 182, 182),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Image.network(
                getImageUrl(widget.recipe.videoUrl.toString()),
                height: 210.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: buildTextSubTitleVariation2(
                          widget.recipe.title.toString()),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 350,
                      child: buildTextSubTitleVariation3(
                          widget.recipe.summary.toString()),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 4),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NutritionStat(
                          img: "assets/home/calories.png",
                          value: widget.recipe.nutrition!.calories.toString()),
                      NutritionStat(
                          img: "assets/home/fat.png",
                          value: widget.recipe.nutrition!.fat.toString()),
                      NutritionStat(
                          img: "assets/home/sugar.png",
                          value: widget.recipe.nutrition!.sugar.toString()),
                      NutritionStat(
                          img: "assets/home/carbs.png",
                          value: widget.recipe.nutrition!.carbohydrates
                              .toString()),
                      NutritionStat(
                          img: "assets/home/protein.png",
                          value: widget.recipe.nutrition!.protein.toString())
                    ]),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTextSubTitleVariation2(String text) {
    return Text(
      text,
      overflow: TextOverflow.clip,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  buildTextSubTitleVariation3(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black45,
      ),
    );
  }

  String getImageUrl(String url) {
    var split = url.split("v=");
    return "https://img.youtube.com/vi/${split[1]}/0.jpg";
  }
}
