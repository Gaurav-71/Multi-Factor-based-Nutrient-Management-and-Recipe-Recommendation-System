import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.pink),
      child: Column(children: [
        const SizedBox(
          height: 50,
        ),
        SizedBox(height: 75, child: SvgPicture.asset("assets/logo-white.svg")),
        const Divider(),
      ]),
    );
  }
}
