import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipedia/screens/navigation/navigation.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Recipedia"),
        ),
        body: const NavScreen());
  }
}
