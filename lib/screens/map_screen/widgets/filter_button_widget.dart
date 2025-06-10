import 'package:flutter/material.dart';

class FilterButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const FilterButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: onPressed,
        tooltip: 'Filter Events',
      ),
    );
  }
}
