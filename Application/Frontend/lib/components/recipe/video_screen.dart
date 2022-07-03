import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:recipedia/components/recipe/ingredient.dart';
import 'package:recipedia/components/recipe/nutrition_stat2.dart';
import 'package:recipedia/models/api_response.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final ApiResponse recipe;
  const VideoScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _muted = true;

  // final String _id = 'nPt8bK2gbaU';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.recipe.videoUrl.toString())
              .toString(),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title.toString()),
      ),
      body: SingleChildScrollView(
        child: YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.pink,
            onReady: () {
              _isPlayerReady = true;
              _controller.setVolume(100);
            },
          ),
          builder: (context, player) => Column(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 310,
                          child: buildTextSubTitleVariation2(
                            _isPlayerReady
                                ? _controller.metadata.title
                                : "Loading Video Title ...",
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 310,
                          child: buildTextSubTitleVariation3(
                            _isPlayerReady
                                ? "by ${_controller.metadata.author}"
                                : "Loading Video Author ...",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 60,
                      child: ElevatedButton(
                        onPressed: _isPlayerReady
                            ? () {
                                _muted
                                    ? _controller.mute()
                                    : _controller.unMute();
                                setState(() {
                                  _muted = !_muted;
                                });
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black12),
                        ),
                        child: Icon(
                          _muted ? Icons.volume_up : Icons.volume_off,
                          color: _muted ? Colors.pink : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 12.0, top: 6.0),
                  child: ReadMoreText(
                    widget.recipe.summary.toString(),
                    trimLines: 5,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: '  Show less',
                    textAlign: TextAlign.justify,
                    moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 16.0, bottom: 14.0),
                child: Row(
                  children: [buildTextSubTitleVariation4("Ingredients")],
                ),
              ),
              ...widget.recipe.ingredients!
                  .map((ingredient) => IngredientCard(
                        ingredient: ingredient,
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 16.0, bottom: 14.0),
                child: Row(
                  children: [buildTextSubTitleVariation4("Nutritional Values")],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Calories.png",
                        nutrient: "Calories",
                        value: widget.recipe.nutrition!.calories.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/NewFat.png",
                        nutrient: "Fat",
                        value: widget.recipe.nutrition!.fat.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Carbohydrates.png",
                        nutrient: "Carbohydrates",
                        value:
                            widget.recipe.nutrition!.carbohydrates.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Fat.png",
                        nutrient: "Saturated Fat",
                        value:
                            widget.recipe.nutrition!.saturatedFat.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Sugar.png",
                        nutrient: "Sugar",
                        value: widget.recipe.nutrition!.sugar.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Cholesterol.png",
                        nutrient: "Cholesterol",
                        value: widget.recipe.nutrition!.cholesterol.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Sodium.png",
                        nutrient: "Sodium",
                        value: widget.recipe.nutrition!.sodium.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Protein.png",
                        nutrient: "Protein",
                        value: widget.recipe.nutrition!.protein.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Vitamin C.png",
                        nutrient: "Vitamin C",
                        value: widget.recipe.nutrition!.vitaminC.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Vitamin-a.png",
                        nutrient: "Vitamin A",
                        value: widget.recipe.nutrition!.vitaminA.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Manganese.png",
                        nutrient: "Manganese",
                        value: widget.recipe.nutrition!.manganese.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/VitaminK.png",
                        nutrient: "Vitamin K",
                        value: widget.recipe.nutrition!.vitaminK.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Dietary Fibre.png",
                        nutrient: "Fiber",
                        value: widget.recipe.nutrition!.fiber.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Potassium.png",
                        nutrient: "Potassium",
                        value: widget.recipe.nutrition!.potassium.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Zinc.png",
                        nutrient: "Zinc",
                        value: widget.recipe.nutrition!.zinc.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Vitamin B6.png",
                        nutrient: "Vitamin B6",
                        value: widget.recipe.nutrition!.vitaminB6.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Copper.png",
                        nutrient: "Copper",
                        value: widget.recipe.nutrition!.copper.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Calcium.png",
                        nutrient: "Calcium",
                        value: widget.recipe.nutrition!.calcium.toString()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NutritionStat2(
                        img: "assets/nutritiondata/Magnesium.png",
                        nutrient: "Magnesium",
                        value: widget.recipe.nutrition!.magnesium.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Phosphor.png",
                        nutrient: "Phosphorus",
                        value: widget.recipe.nutrition!.phosphorus.toString()),
                    NutritionStat2(
                        img: "assets/nutritiondata/Iron.png",
                        nutrient: "Iron",
                        value: widget.recipe.nutrition!.iron.toString()),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              )
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
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  buildTextSubTitleVariation4(String text) {
    return Text(
      text,
      overflow: TextOverflow.clip,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.pink,
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
}
