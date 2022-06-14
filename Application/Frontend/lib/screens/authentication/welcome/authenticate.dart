import 'package:flutter/material.dart';
import 'package:recipedia/components/background.dart';
import 'package:recipedia/screens/authentication/welcome/buttons.dart';
import 'package:recipedia/screens/authentication/welcome/image.dart';

class Authenticate extends StatelessWidget {
  const Authenticate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const WelcomeImage(),
          Row(
            children: const [
              Spacer(),
              Expanded(
                flex: 8,
                child: LoginAndSignupBtn(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
