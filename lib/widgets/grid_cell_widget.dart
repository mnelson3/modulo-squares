// /Users/marknelson/Circus/modulo-flutter-project/lib/widgets/grid_cell_widget.dart
import 'package:flutter/material.dart';

class GridCellWidget extends StatelessWidget {
  final int? value;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isPossibleTarget;
  final bool justChanged;

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
    // Use theme colors for better consistency and accessibility
    final theme = Theme.of(context);
    Color cellColor = theme.colorScheme.surfaceContainerHighest;
    double borderWidth = 0.5;

    if (isSelected) {
      cellColor = theme.colorScheme.primaryContainer;
    } else if (isPossibleTarget) {
      cellColor = Colors.yellow.shade200;
    } else if (value != null) {
      cellColor = theme.colorScheme.secondaryContainer;
    }
    if (justChanged) {
      cellColor = Colors.orange.shade200;
      borderWidth = 2.0;
    }

    return Semantics(
      label: value != null ? 'Cell $value' : 'Empty cell',
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: cellColor,
            border: Border.all(color: theme.colorScheme.outline, width: borderWidth),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              value?.toString() ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
