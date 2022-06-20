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
import 'package:recipedia/model/user_data.dart';
import 'package:recipedia/services/database.dart';

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

  @override
  void initState() {
    super.initState();
    userData = List<List<dynamic>>.empty(growable: true);
    userUid = "";
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
          return const Text("Loading");
        }

        if (snapshot.data?.data() != null) {
          var temp = snapshot.data?.data();
          return Text(temp!['uid'].toString());
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
}
