import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Error extends StatelessWidget {
  final String message;
  const Error({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Center(
            child: SizedBox(
          height: 120,
          child: Image.asset('assets/images/error.png'),
        )),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 350,
          child: buildTextSubTitleVariation2(message),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () {
                Phoenix.rebirth(context);
              },
              child: Text("Restart App".toUpperCase())),
        )
      ],
    );
  }

  buildTextSubTitleVariation2(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      overflow: TextOverflow.clip,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
