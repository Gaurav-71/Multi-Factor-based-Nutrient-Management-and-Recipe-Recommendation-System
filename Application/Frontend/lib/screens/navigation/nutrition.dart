import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipedia/constants.dart';

class NutritionTab extends StatefulWidget {
  const NutritionTab({Key? key}) : super(key: key);

  @override
  State<NutritionTab> createState() => _NutritionTabState();
}

class _NutritionTabState extends State<NutritionTab> {
  late List<List<dynamic>> userData;
  List<PlatformFile>? _paths;
  final String? _extension = "csv";
  final FileType _pickingType = FileType.custom;

  @override
  void initState() {
    super.initState();
    userData = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
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
                      "Upload new data".toUpperCase(),
                    )),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
          const Divider(),
          Expanded(
              child: userData.isNotEmpty
                  ? ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userData[index][0]),
                                Text(userData[index][1]),
                                Text(userData[index][2]),
                              ],
                            ),
                          ),
                        );
                      })
                  : Text("No data provided")),
        ]);
  }

  openFile(filepath) async {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);
    setState(() {
      userData = fields;
    });
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);
    });
  }
}
