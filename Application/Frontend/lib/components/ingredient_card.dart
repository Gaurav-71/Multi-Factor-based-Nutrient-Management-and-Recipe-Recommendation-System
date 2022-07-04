import 'package:flutter/material.dart';
import 'package:recipedia/constants.dart';

class PreferencesIngredientCard extends StatefulWidget {
  final String ingredient;
  final bool? selected;
  const PreferencesIngredientCard(
      {Key? key, required this.ingredient, required this.selected})
      : super(key: key);

  @override
  State<PreferencesIngredientCard> createState() =>
      _PreferencesIngredientCardState();
}

class _PreferencesIngredientCardState extends State<PreferencesIngredientCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: 12.0),
      color: widget.selected! ? Colors.red : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(
              widget.ingredient,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: widget.selected! ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
