import 'package:flutter/material.dart';
import 'package:recipedia/components/background.dart';
import 'package:recipedia/services/auth.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Firebase Auth Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await _authService.signOut();
          },
          label: const Text("Logout"),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
