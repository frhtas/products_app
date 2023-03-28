import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData iconData;
  final String text;

  const EmptyStateWidget({
    super.key,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
