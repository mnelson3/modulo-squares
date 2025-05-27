// /Users/marknelson/Circus/modulo-flutter-project/lib/widgets/grid_cell_widget.dart
import 'package:flutter/material.dart';

class GridCellWidget extends StatelessWidget {
  final int? value;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPossibleTarget; // New: to highlight possible move locations
  final bool justChanged; // To provide feedback on value change

  const GridCellWidget({
    super.key,
    required this.value,
    required this.isSelected,
    required this.onTap,
    this.isPossibleTarget = false,
    this.justChanged = false,
  });

  @override
  Widget build(BuildContext context) {
    Color cellColor = Colors.grey.shade300; // Default for empty
    double borderWidth = 0.5;

    if (isSelected) {
      cellColor = Colors.blue.shade200;
    } else if (isPossibleTarget) {
      cellColor = Colors.yellow.shade200;
    } else if (value != null) {
      cellColor = Colors.teal.shade100;
    }
    if (justChanged) {
      cellColor = Colors.orange.shade200; // Highlight for changed cell
      borderWidth = 2.0; // Make border thicker for emphasis
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation duration
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(color: Colors.black54, width: borderWidth),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Center(
          child: Text(
            value?.toString() ?? '',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
