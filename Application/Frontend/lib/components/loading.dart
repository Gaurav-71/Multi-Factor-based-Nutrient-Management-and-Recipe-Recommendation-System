import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipedia/constants.dart';

class Loading extends StatelessWidget {
  final String message;
  const Loading({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: SpinKitSpinningLines(
            color: kPrimaryColor,
            size: 60.0,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(message)
      ],
    );
  }
}
