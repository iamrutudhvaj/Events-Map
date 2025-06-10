import 'package:flutter/material.dart';

class FilterHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onRefresh;

  const FilterHeaderWidget({super.key, required this.title, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (onRefresh != null)
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: onRefresh,
            ),
        ],
      ),
    );
  }
}
