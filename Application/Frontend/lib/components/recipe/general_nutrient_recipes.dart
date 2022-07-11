import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipedia/components/error.dart';
import 'package:recipedia/components/loading.dart';
import 'package:recipedia/components/recipe/smaller_recipe_card.dart';
import 'package:recipedia/models/api_response.dart';
import 'package:http/http.dart' as http;

class GeneralNutrientRecipes extends StatefulWidget {
  final String title;
  final String subtitle;
  final String url;
  const GeneralNutrientRecipes(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.url})
      : super(key: key);

  @override
  State<GeneralNutrientRecipes> createState() => _GeneralNutrientRecipesState();
}

class _GeneralNutrientRecipesState extends State<GeneralNutrientRecipes> {
  late Future<List<ApiResponse>> apiResponse;
  bool loadingApiResponse = false;
  bool serverError = false;

  @override
  void initState() {
    super.initState();
    try {
      apiResponse = fetchApiResponse();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            buildTextTitleVariation1(widget.title),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            buildTextSubTitleVariation2(widget.subtitle),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        !loadingApiResponse && !serverError
            ? FutureBuilder<List<ApiResponse>>(
                future: apiResponse,
                builder: (context, apiSnapshot) {
                  if (apiSnapshot.hasData) {
                    return SizedBox(
                      width: double.infinity,
                      height: 280,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: apiSnapshot.data!.length,
                          itemBuilder: ((context, index) {
                            final recipe = apiSnapshot.data![index];
                            return SmallerRecipeCard(
                              recipe: recipe,
                            );
                          })),
                    );
                  } else {
                    return const Error(message: "Error, no data found");
                  }
                })
            : serverError
                ? const Error(
                    message:
                        "Server error, check the backend server and restart the application")
                : Column(children: const [
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Loading(message: "Loading Recipes"),
                    )
                  ]),
      ],
    );
  }

  buildTextTitleVariation1(String text) {
    return Text(
      text,
      style: GoogleFonts.staatliches(
          fontSize: 25,
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
          fontSize: 15,
          color: Colors.black45,
        ),
      ),
    );
  }

  Future<List<ApiResponse>> fetchApiResponse() async {
    debugPrint("${widget.title} API called");
    setState(() {
      loadingApiResponse = true;
    });
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      List<ApiResponse> myModels = (json.decode(response.body) as List)
          .map((i) => ApiResponse.fromJson(i))
          .toList();
      setState(() {
        loadingApiResponse = false;
        serverError = false;
      });
      return myModels;
    } else {
      setState(() {
        loadingApiResponse = false;
        serverError = true;
      });
      throw Exception(
          'SERVER ERROR : Failed to load ${widget.title} Api Response');
    }
  }
}
