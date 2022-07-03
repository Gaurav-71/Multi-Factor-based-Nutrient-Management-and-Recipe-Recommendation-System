import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipedia/screens/navigation/navigation.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          title: SizedBox(
              height: 70, child: SvgPicture.asset("assets/logo-white.svg")),
        ),
        body: const NavScreen());
  }
}
