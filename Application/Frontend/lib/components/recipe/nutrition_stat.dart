import 'package:flutter/material.dart';

class NutritionStat extends StatefulWidget {
  final String img;
  final String value;
  const NutritionStat({Key? key, required this.img, required this.value})
      : super(key: key);

  @override
  State<NutritionStat> createState() => _NutritionStatState();
}

class _NutritionStatState extends State<NutritionStat> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          child: Image.asset(widget.img),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(widget.value)
      ],
    );
  }
}
