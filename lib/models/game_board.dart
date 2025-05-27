// /Users/marknelson/Circus/modulo-flutter-project/lib/models/game_board.dart
import 'dart:math';

class GameBoard {
  final int rows;
  final int cols;
  late List<List<int?>> _grid;
  final List<List<List<int?>>> _history = []; // Store previous grid states

  GameBoard({required this.rows, required this.cols}) {
	if (rows <= 0 || cols <= 0) {
	  throw ArgumentError("Rows and columns must be positive.");
	}
	_grid = List.generate(rows, (_) => List.generate(cols, (_) => null));
  }

  int? getValue(int row, int col) {
	if (_isValidCoordinate(row, col)) {
	  return _grid[row][col];
	}
	return null; // Or throw error
  }

  void setValue(int row, int col, int? value) {
	if (_isValidCoordinate(row, col)) {
	  _grid[row][col] = value;
	}
  }

  bool _isValidCoordinate(int row, int col) {
	return row >= 0 && row < rows && col >= 0 && col < cols;
  }

  bool moveCell(int fromRow, int fromCol, int toRow, int toCol) {
	if (!_isValidCoordinate(fromRow, fromCol) ||
		!_isValidCoordinate(toRow, toCol)) {
	  return false; // Invalid coordinates
	}
	if (fromRow == toRow && fromCol == toCol) {
	  return false; // Cannot move to the same cell
	}

	// Ensure move is strictly horizontal or vertical by one step
	bool isAdjacent = ((fromRow == toRow && (fromCol - toCol).abs() == 1) ||
		(fromCol == toCol && (fromRow - toRow).abs() == 1));
	if (!isAdjacent) {
	  return false; // Not an adjacent cell
	}

	int? sourceValue = _grid[fromRow][fromCol];
	int? targetValue = _grid[toRow][toCol];

	if (sourceValue == null) {
	  return false; // Cannot move an empty cell
	}

	if (targetValue == null) {
	  // Moving to an empty cell
	  _grid[toRow][toCol] = sourceValue;
	  _grid[fromRow][fromCol] = null;
	  return true;
	} else {
	  // Moving to an occupied cell: apply modulo logic
	  // "if the square moved (sourceValue) is less than or equal to the square moved into it (targetValue)"
	  if (sourceValue <= targetValue) {
		if (sourceValue == 0) {
		  return false; // Avoid division by zero if 0 is allowed
		}

		int remainder = targetValue % sourceValue;
		if (remainder == 0) {
		  _grid[toRow][toCol] = null; // Target becomes empty
		} else {
		  _grid[toRow][toCol] = remainder; // Target populated by result
		}
		_grid[fromRow][fromCol] = null; // Source becomes empty
		return true;
	  } else {
		// Condition (sourceValue <= targetValue) not met. Move is disallowed.
		// Or, alternatively, the source could still empty if that's desired game behavior.
		// For now, let's say the move doesn't happen if condition fails.
		return false;
	  }
	}
  }

  bool isBoardClear() {
	for (int r = 0; r < rows; r++) {
	  for (int c = 0; c < cols; c++) {
		if (_grid[r][c] != null) {
		  return false;
		}
	  }
	}
	return true;
  }

  void resetBoard() {
	_grid = List.generate(rows, (_) => List.generate(cols, (_) => null));
  }

  void populateRandomly({int numbersToPlace = 6, int maxCellValue = 20}) {
	resetBoard();
	if (numbersToPlace > rows * cols) numbersToPlace = rows * cols;

	Random random = Random();
	int placedCount = 0;

	// Ensure numbers are > 0 for modulo, and typically > 1 for interesting results.
	// Min value should be 1, as 0 % X is 0, and X % 0 is an error.
	int minVal = 1;
	if (maxCellValue <= minVal) maxCellValue = minVal + 1;

	while (placedCount < numbersToPlace) {
	  int r = random.nextInt(rows);
	  int c = random.nextInt(cols);
	  if (_grid[r][c] == null) {
		_grid[r][c] = random.nextInt(maxCellValue - minVal + 1) + minVal;
		placedCount++;
	  }
	}
  }

  void printBoard() {
	// For debugging
	for (int r = 0; r < rows; r++) {
	  // ignore: avoid_print
	  print(_grid[r].map((e) => e?.toString().padLeft(2) ?? '--').join(' | '));
	}
  }
}
