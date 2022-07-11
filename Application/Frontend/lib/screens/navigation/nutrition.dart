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
import 'package:recipedia/constants.dart';
import 'package:recipedia/services/database.dart';

class NutritionTab extends StatefulWidget {
  const NutritionTab({Key? key}) : super(key: key);

  @override
  State<NutritionTab> createState() => _NutritionTabState();
}

class _NutritionTabState extends State<NutritionTab> {
  late List<List<dynamic>> userData;
  late String? userUid;
  List<PlatformFile>? _paths;
  final String _extension = "csv";
  final FileType _pickingType = FileType.custom;

  final DatabaseService _databaseService = DatabaseService();

  List<dynamic> skipIngredients = [];

  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    super.initState();
    userData = List<List<dynamic>>.empty(growable: true);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    setState(() {
      userUid = user?.uid;
    });
    final Stream<DocumentSnapshot<Map<String, dynamic>>> downloadedUserData =
        FirebaseFirestore.instance
            .collection('NutritionData')
            .doc(user?.uid)
            .snapshots();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: downloadedUserData,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          var snapshotData = snapshot.data?.data();
          var snapshotDataAsList = [];
          snapshotData?.entries
              .map((e) => snapshotDataAsList.add([e.key, e.value]))
              .toList();
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
                          height: 150,
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
                            "Upload new data".toUpperCase(),
                          )),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(),
                Expanded(
                    child: snapshotDataAsList.isNotEmpty
                        ? ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshotDataAsList.length,
                            itemBuilder: (context, index) {
                              if (snapshotDataAsList[index][0].toString() ==
                                  'skipIngredients') {
                                skipIngredients = [];
                                skipIngredients
                                    .addAll(snapshotDataAsList[index][1]);
                              }
                              return snapshotDataAsList[index][0].toString() !=
                                      'skipIngredients'
                                  ? Card(
                                      margin: const EdgeInsets.only(
                                          left: defaultPadding,
                                          right: defaultPadding,
                                          top: 12.0),
                                      color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Image.asset(
                                              "assets/nutritiondata/${snapshotDataAsList[index][0].toString()}.png",
                                              height: 35,
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshotDataAsList[index][0]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(snapshotDataAsList[index]
                                                        [1]
                                                    .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Text("");
                            })
                        : const Text("No data provided")),
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                snapshotDataAsList.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _scrollPosition < 1600.0
                              ? const Text(
                                  "Scroll down to view more parameters",
                                )
                              : const Icon(
                                  Icons.keyboard_double_arrow_up_outlined,
                                  color: kPrimaryColor,
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                          _scrollPosition < 1600.0
                              ? const Icon(
                                  Icons.keyboard_double_arrow_down_outlined,
                                  color: kPrimaryColor,
                                )
                              : const Text("Scroll up to view more parameters"),
                        ],
                      )
                    : const Text(""),
                const SizedBox(
                  height: 15,
                )
              ]);
        });
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
      debugPrint("Unsupported operation ${e.toString()}");
    } catch (ex) {
      debugPrint(ex.toString());
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
    });
  }
}
