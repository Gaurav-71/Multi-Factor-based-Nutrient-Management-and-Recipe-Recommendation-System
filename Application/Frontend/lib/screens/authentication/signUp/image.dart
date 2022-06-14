import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:recipedia/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
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
              flex: 10,
              child: SizedBox(
                  height: 260,
                  child: SvgPicture.asset("assets/auth/signup.svg")),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
