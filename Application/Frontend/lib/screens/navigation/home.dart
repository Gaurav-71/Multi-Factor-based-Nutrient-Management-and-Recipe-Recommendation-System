import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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
          return Column(
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
                          child: SvgPicture.asset("assets/images/upload.svg")),
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
    createMap();
    _databaseService.uploadData(userUid, createMap());
  }

  createMap() {
    var map = <String, dynamic>{};
    for (var i = 0; i < userData.length; i++) {
      var temp = userData[i];
      map[temp[0].toString()] = temp[1].toString();
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

  Future<List<ApiResponse>> fetchApiResponse() async {
    setState(() {
      loadingApiResponse = true;
    });
    final response = await http.get(Uri.parse('http://127.0.0.1:5000'));
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
