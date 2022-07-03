import 'package:flutter/material.dart';

class NutritionStat2 extends StatefulWidget {
  final String img;
  final String nutrient;
  final String value;
  const NutritionStat2(
      {Key? key,
      required this.img,
      required this.value,
      required this.nutrient})
      : super(key: key);

  @override
  State<NutritionStat2> createState() => _NutritionStat2State();
}

class _NutritionStat2State extends State<NutritionStat2> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
            child: Image.asset(widget.img),
          ),
          const SizedBox(
            width: 3,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nutrient,
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                widget.value,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
