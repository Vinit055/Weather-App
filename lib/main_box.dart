import 'package:flutter/material.dart';

class MainBox extends StatelessWidget {
  final String temp;
  final String sky;
  final IconData mainCardIcon;
  const MainBox(
      {super.key,
      required this.temp,
      required this.sky,
      required this.mainCardIcon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Mumbai, India'),
          const SizedBox(
            height: 7,
          ),
          Text(
            temp,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            mainCardIcon,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            sky,
            style: TextStyle(
              fontSize: 20,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
