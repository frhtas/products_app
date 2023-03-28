import 'package:flutter/material.dart';

class AddRemoveWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final double buttonSize;
  final double iconSize;
  final double textSize;

  const AddRemoveWidget({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.buttonSize = 32,
    this.iconSize = 24,
    this.textSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onRemove,
          child: Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: textSize,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: iconSize,
            ),
          ),
        ),
      ],
    );
  }
}
