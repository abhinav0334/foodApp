import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String label;

  const FilterChips(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label),
    );
  }
}


