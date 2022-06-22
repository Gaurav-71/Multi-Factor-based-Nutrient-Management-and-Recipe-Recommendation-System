import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipedia/constants.dart';
import 'package:recipedia/services/auth.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 10,
              child: SizedBox(
                  height: 380,
                  child: SvgPicture.asset("assets/auth/logout.svg")),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Text("Email ID : ${_authService.currentUser()?.email}"),
        const SizedBox(
          height: 20.0,
        ),
        Text("UID : ${_authService.currentUser()?.uid}"),
        const SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: ElevatedButton.icon(
                  onPressed: () async {
                    await _authService.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(
                    "Sign Out".toUpperCase(),
                  )),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
