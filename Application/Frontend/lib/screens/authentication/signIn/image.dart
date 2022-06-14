import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:recipedia/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 4,
              child: SizedBox(
                  height: 55, child: SvgPicture.asset("assets/logo.svg")),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 100,
              child: SizedBox(
                  height: 280,
                  child: SvgPicture.asset("assets/auth/login.svg")),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
