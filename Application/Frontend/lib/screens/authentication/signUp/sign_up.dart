import 'package:flutter/material.dart';
import 'package:recipedia/components/background.dart';
import 'package:recipedia/screens/authentication/signUp/image.dart';
import 'package:recipedia/screens/authentication/signUp/sign_up_form.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SignUpScreenTopImage(),
          Row(
            children: const [
              Spacer(),
              Expanded(
                flex: 8,
                child: SignUpForm(),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
