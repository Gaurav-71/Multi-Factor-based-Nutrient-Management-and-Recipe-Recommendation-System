import 'package:flutter/material.dart';
import 'package:recipedia/models/api_response.dart';

class IngredientCard extends StatefulWidget {
  final Ingredients ingredient;
  const IngredientCard({Key? key, required this.ingredient}) : super(key: key);

  @override
  State<IngredientCard> createState() => _IngredientCardState();
}

class _IngredientCardState extends State<IngredientCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Color.fromARGB(96, 239, 182, 182),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black87,
                radius: 22,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.ingredient.imgUrl.toString()),
                  radius: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.ingredient.name.toString())
            ],
          ),
        ),
      ),
    );
  }
}
