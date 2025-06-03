// /Users/marknelson/Circus/modulo-flutter-project/lib/models/game_board.dart
import 'dart:math';
import 'package:modulo_flutter_project/utils/game_utils.dart';

class GameBoard {
  final int rows;
  final int cols;
  final int maxValue;
  late List<List<int?>> grid;
  int score = 0;

  final Random _random = Random();

  GameBoard({required this.rows, required this.cols, required this.maxValue}) {
    reset();
  }

  void reset() {
    grid = List.generate(
      rows,
      (_) => List.generate(cols, (_) => _random.nextInt(maxValue) + 1),
    );
    score = 0;
  }

  bool isInBounds(int row, int col) => row >= 0 && row < rows && col >= 0 && col < cols;

  bool move(int row, int col, int dRow, int dCol) {
    int newRow = row + dRow;
    int newCol = col + dCol;
    if (!isInBounds(newRow, newCol)) return false;

    int? fromValue = grid[row][col];
    int? toValue = grid[newRow][newCol];

    if (fromValue != null && toValue != null && fromValue <= toValue) {
      int result = toValue % fromValue;
      grid[newRow][newCol] = result != 0 ? result : null;
      grid[row][col] = null;
      score += 1;
      return true;
    }
    return false;
  }

  bool isBoardClear() => grid.every((row) => row.every((cell) => cell == null));

  bool hasMoves() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int? current = grid[i][j];
        if (current == null) continue;
        for (var dir in [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ]) {
          int ni = i + dir[0];
          int nj = j + dir[1];
          if (isInBounds(ni, nj) && grid[ni][nj] != null && current <= grid[ni][nj]!) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
