import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipedia/constants.dart';

class NutritionTab extends StatefulWidget {
  const NutritionTab({Key? key}) : super(key: key);

  @override
  State<NutritionTab> createState() => _NutritionTabState();
}

class _NutritionTabState extends State<NutritionTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(
        height: defaultPadding * 2,
      ),
      Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 100,
            child: SizedBox(
                height: 200,
                child: SvgPicture.asset("assets/images/upload.svg")),
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(
        height: defaultPadding * 2,
      ),
      Row(
        children: [
          const Spacer(),
          Expanded(
            flex: 8,
            child: ElevatedButton.icon(
                onPressed: () async {},
                icon: const Icon(Icons.file_upload),
                label: Text(
                  "Upload new data".toUpperCase(),
                )),
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(
        height: defaultPadding * 2,
      ),
      const Divider()
    ]);
  }
}
