import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipedia/components/ingredient_card.dart';
import 'package:recipedia/components/loading.dart';
import 'package:recipedia/components/recipe/recipe_screen.dart';
import 'package:recipedia/constants.dart';
import 'package:recipedia/models/api_response.dart';
import 'package:recipedia/services/database.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<List<dynamic>> userData;
  late String? userUid;
  List<PlatformFile>? _paths;
  final String _extension = "csv";
  final FileType _pickingType = FileType.custom;

  final DatabaseService _databaseService = DatabaseService();

  var stepCount = 0;
  var vegOrNonVeg = "";
  List<String> ingredients = [];
  List<String> skipIngredients = [];

  List<bool?> selected = [];

  final vegIngredients = [
    "Agathi leaves",
    "Allathi",
    "Almond",
    "Aluva",
    "Amaranth leaves",
    "Amaranth seed",
    "Amaranth spinosus",
    "Anchovy",
    "Apple",
    "Apricot",
    "Arecanut",
    "Asafoetida",
    "Ash gourd",
    "Avocado fruit",
    "Bael fruit",
    "Bajra",
    "Bamboo shoot",
    "Banana",
    "Barley",
    "Basella leaves",
    "Bathua leaves",
    "Bean scarlet",
    "Beet greens",
    "Beet root",
    "Bengal gram",
    "Betel leaves",
    "Bitter gourd",
    "Black berry",
    "Black gram",
    "Bottle gourd",
    "Brinjal",
    "Broad beans",
    "Brussels sprouts",
    "Button mushroom",
    "Cabbage",
    "Capsicum",
    "Cardamom",
    "Carrot",
    "Cashew nut",
    "Cauliflower",
    "Cauliflower leaves",
    "Celery stalk",
    "Cherries",
    "Chicken mushroom",
    "Chillies",
    "Cho",
    "Cloves",
    "Cluster beans",
    "Coconut",
    "Coconut Water",
    "Colocasia",
    "Colocasia leaves",
    "Coriander leaves",
    "Coriander seeds",
    "Corn",
    "Cucumber",
    "Cumin seeds",
    "Currants",
    "Curry leaves",
    "Custard apple",
    "Dates",
    "Drumstick",
    "Drumstick leaves",
    "Fenugreek leaves",
    "Fenugreek seeds",
    "Field bean",
    "Field beans",
    "Fig",
    "French beans",
    "Garden cress",
    "Garlic",
    "Gingelly seeds",
    "Ginger",
    "Gobro",
    "Gogu leaves",
    "Goosberry",
    "Grapes",
    "Green gram",
    "Ground nut",
    "Guava",
    "Horse gram",
    "Jack fruit",
    "Jaggery",
    "Jallal",
    "Jambu fruit",
    "Jowar",
    "Kadal bral",
    "Kadali",
    "Kalava",
    "Kanamayya",
    "Karnagawala",
    "Karonda fruit",
    "Kayrai",
    "Khoa",
    "Knol",
    "Korka",
    "Kovai",
    "Ladies finger",
    "Lemon",
    "Lentil dal",
    "Lentil whole",
    "Lettuce",
    "Lime",
    "Linseeds",
    "Litchi",
    "Lotus root",
    "Mace",
    "Maize",
    "Mango",
    "Mango ginger",
    "Mangosteen",
    "Manila tamarind",
    "Milk",
    "Mint leaves",
    "Mithun",
    "Moth bean",
    "Mud crab",
    "Mullet",
    "Musk melon",
    "Mustard leaves",
    "Mustard seeds",
    "Niger seeds",
    "Nutmeg",
    "Omum",
    "Onion",
    "Orange",
    "Oyster mushroom",
    "Paarai",
    "Padayappa",
    "Pak Choi leaves",
    "Palm fruit",
    "Pambada",
    "Pandukopa",
    "Paneer",
    "Pangas",
    "Papaya",
    "Parava",
    "Parcus",
    "Parsley",
    "Parwar",
    "Peach",
    "Pear",
    "Peas",
    "Pepper",
    "Phalsa",
    "Phopat",
    "Pine seed",
    "Pineapple",
    "Pippali",
    "Pistachio nuts",
    "Plantain",
    "Plum",
    "Pomegranate",
    "Ponnaganni",
    "Poppy seeds",
    "Potato",
    "Pummelo",
    "Pumpkin",
    "Pumpkin leaves",
    "Quinoa",
    "Radish",
    "Radish leaves",
    "Ragi",
    "Raisins",
    "Rajmah",
    "Rambutan",
    "Rani",
    "Red gram",
    "Rice",
    "Rice flakes",
    "Rice puffed",
    "Ricebean",
    "Ridge gourd",
    "Rumex leaves",
    "Sadaya",
    "Safflower seeds",
    "Samai",
    "Sangada",
    "Sankata paarai",
    "Sapota",
    "Shiitake mushroom",
    "Snake gourd",
    "Soursop",
    "Soybean",
    "Spinach",
    "Star fruit",
    "Strawberry",
    "Sugarcane",
    "Sunflower seeds",
    "Sweet potato",
    "Tamarind",
    "Tamarind leaves",
    "Tapioca",
    "Tarlava",
    "Tholam",
    "Tinda",
    "Tomato",
    "Turmeric powder",
    "Varagu",
    "Vora",
    "Walnut",
    "Water Chestnut",
    "Water melon",
    "Wheat",
    "Wheat flour",
    "Wood Apple",
    "Yam",
    "Zizyphus",
    "Zucchini",
  ];
  final nonVegIngredients = [
    "Ari fish",
    "Beef",
    "Betki",
    "Xiphinis",
    "Whale shark",
    "Vela meen",
    "Vanjaram",
    "Tuna",
    "Turkey",
    "Tiger prawns",
    "Tilapia",
    "Stingray",
    "Squid",
    "Sole fish",
    "Silk fish",
    "Silver carp",
    "Silan",
    "Shelavu",
    "Sardine",
    "Shark",
    "Sheep",
    "Salmon",
    "Rohu",
    "Red snapper",
    "Ray fish",
    "Rabbit",
    "Raai fish",
    "Raai vanthu",
    "Quail",
    "Queen fish",
    "Poultry, chicken",
    "Pranel",
    "Prawns",
    "Pulli paarai",
    "Pork",
    "Pomfret",
    "Piranha",
    "Perinkilichai",
    "Parrot fish",
    "Pali kora",
    "Oyster",
    "Octopus",
    "Myil meen",
    "Nalla bontha",
    "Narba",
    "Mural",
    "Moon fish",
    "Milk fish",
    "Matha",
    "Manda clathi",
    "Mackerel",
    "Maagaa",
    "Lobster",
    "Kulam paarai",
    "Kite fish",
    "Kiriyan",
    "Kannadi paarai",
    "Karimeen",
    "Kalamaara",
    "Jathi vela meen",
    "Hare",
    "Hilsa",
    "Guinea fowl",
    "Guitar fish",
    "Gold fish",
    "Goat",
    "Freshwater Eel",
    "Duck",
    "Egg, country hen",
    "Egg, duck",
    "Egg, poultry",
    "Egg, quial",
    "Eggs",
    "Emu",
    "Eri meen",
    "Country hen",
    "Crab",
    "Clam",
    "Chicken, poultry",
    "Chakla",
    "Chelu",
    "Chembali",
    "Cat fish",
    "Catla",
    "Calf",
    "Bommuralu",
    "Black snapper",
    "Bombay duck",
  ];

  late Future<List<ApiResponse>> apiResponse;
  bool loadingApiResponse = false;

  @override
  void initState() {
    super.initState();
    userData = List<List<dynamic>>.empty(growable: true);
    userUid = "";
    apiResponse = fetchApiResponse();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    setState(() {
      userUid = user?.uid;
    });
    final Stream<DocumentSnapshot<Map<String, dynamic>>> userData =
        FirebaseFirestore.instance
            .collection('NutritionData')
            .doc(user?.uid)
            .snapshots();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: userData,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading(message: "Fetching user Data");
        }

        if (snapshot.data?.data() != null) {
          return !loadingApiResponse
              ? FutureBuilder<List<ApiResponse>>(
                  future: apiResponse,
                  builder: (context, apiSnapshot) {
                    if (apiSnapshot.hasData) {
                      return RecipeScreen(recipes: apiSnapshot.data);
                    } else if (apiSnapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return const Text("Error");
                    }
                  })
              : Column(children: const [
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Loading(
                        message: "Loading recipes tailor made for you !"),
                  )
                ]);
        } else {
          return stepCount == 0
              ? Column(
                  children: [
                    const SizedBox(
                      height: defaultPadding * 3,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 100,
                          child: SizedBox(
                              height: 250,
                              child: SvgPicture.asset("assets/home/chef.svg")),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    buildTextTitleVariation1("User Preferences"),
                    buildTextSubTitleVariation2(
                        "Are you a vegetarian or non-vegetarian ?"),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 6,
                          child: ElevatedButton.icon(
                            onPressed: () => {setVegOrNonVeg("veg")},
                            icon: const Icon(Icons.soup_kitchen),
                            label: Text(
                              "Veg".toUpperCase(),
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          flex: 6,
                          child: ElevatedButton.icon(
                            onPressed: () => {setVegOrNonVeg("non-veg")},
                            icon: const Icon(Icons.egg_alt_outlined),
                            label: Text(
                              "Non Veg".toUpperCase(),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red[600]),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                )
              : stepCount == 1
                  ? Column(
                      children: [
                        const SizedBox(
                          height: defaultPadding * 2,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 100,
                              child: SizedBox(
                                  height: 150,
                                  child: SvgPicture.asset(
                                      "assets/home/allergy.svg")),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        buildTextTitleVariation1("User Preferences"),
                        const SizedBox(
                          height: 5,
                        ),
                        buildTextSubTitleVariation2(
                            "Select any ingredient you don't like or you are allergic to"),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: ingredients.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: selected[index],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          selected[index] = value;
                                          if (value == true) {
                                            skipIngredients
                                                .add(ingredients[index]);
                                          } else {
                                            skipIngredients
                                                .remove(ingredients[index]);
                                          }
                                        });
                                      },
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: PreferencesIngredientCard(
                                          ingredient: ingredients[index],
                                          selected: selected[index]),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: ElevatedButton(
                                onPressed: back,
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey),
                                child: Text(
                                  "Back".toUpperCase(),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 8,
                              child: ElevatedButton(
                                  onPressed: next,
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.pink),
                                  child: Text(
                                    "Next".toUpperCase(),
                                  )),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                          const SizedBox(
                            height: defaultPadding * 2,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 100,
                                child: SizedBox(
                                    height: 200,
                                    child: SvgPicture.asset(
                                        "assets/images/upload.svg")),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding * 2,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 8,
                                child: ElevatedButton.icon(
                                    onPressed: _openFileExplorer,
                                    icon: const Icon(Icons.file_upload),
                                    label: Text(
                                      "Upload your data".toUpperCase(),
                                    )),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: defaultPadding,
                          ),
                        ]);
        }
      },
    );
  }

  openFile(filepath) async {
    File f = File(filepath);
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    setState(() {
      userData = fields;
    });
    userData.add(["uid", userUid]);
    userData.add(["skipIngredients", skipIngredients]);
    _databaseService.uploadData(userUid, createMap());
  }

  createMap() {
    var map = <String, dynamic>{};
    for (var i = 0; i < userData.length; i++) {
      var temp = userData[i];
      if (temp[0].toString() == 'skipIngredients') {
        map[temp[0].toString()] = temp[1];
      } else {
        map[temp[0].toString()] = temp[1].toString();
      }
    }
    return map;
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension.isNotEmpty)
            ? _extension.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation ${e.toString()}");
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
    });
  }

  next() {
    if (stepCount < 2) {
      setState(() {
        stepCount += 1;
      });
    }
  }

  back() {
    if (stepCount > 0) {
      setState(() {
        stepCount -= 1;
      });
    }
  }

  setVegOrNonVeg(preference) {
    setState(() {
      skipIngredients = [];
      selected = [];
      vegOrNonVeg = preference;
      if (preference == 'veg') {
        ingredients = vegIngredients;
        skipIngredients.addAll(nonVegIngredients);
      } else {
        ingredients = nonVegIngredients;
      }
      selected = ingredients.map((e) => false).toList();
    });
    next();
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
        textAlign: TextAlign.center,
        overflow: TextOverflow.clip,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
    );
  }

  Future<List<ApiResponse>> fetchApiResponse() async {
    print("api called");
    setState(() {
      loadingApiResponse = true;
    });
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/mock-personalised-recipes'));
    if (response.statusCode == 200) {
      List<ApiResponse> myModels = (json.decode(response.body) as List)
          .map((i) => ApiResponse.fromJson(i))
          .toList();
      setState(() {
        loadingApiResponse = false;
      });
      return myModels;
    } else {
      throw Exception('Failed to load Api Response');
    }
  }
}
