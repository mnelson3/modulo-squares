import 'package:flutter_test/flutter_test.dart';
import 'package:modulo/models/game_board.dart';

void main() {
  group('GameBoard', () {
    test('initializes with correct size and non-null values', () {
      final board = GameBoard(rows: 4, cols: 4, maxValue: 10);
      expect(board.grid.length, 4);
      expect(board.grid[0].length, 4);
      expect(board.grid.expand((row) => row).where((cell) => cell != null).length, 16);
    });

    test('move returns false for out-of-bounds', () {
      final board = GameBoard(rows: 4, cols: 4, maxValue: 10);
      expect(board.move(-1, 0, 1, 0), false);
      expect(board.move(0, -1, 0, 1), false);
      expect(board.move(4, 0, 1, 0), false);
      expect(board.move(0, 4, 0, 1), false);
    });

    test('reset clears score and reinitializes grid', () {
      final board = GameBoard(rows: 4, cols: 4, maxValue: 10);
      board.score = 5;
      board.grid[0][0] = null;
      board.reset();
      expect(board.score, 0);
      expect(board.grid[0][0], isNotNull);
    });

    test('isBoardClear returns true only if all cells are null', () {
      final board = GameBoard(rows: 2, cols: 2, maxValue: 10);
      board.grid = [
        [null, null],
        [null, null],
      ];
      expect(board.isBoardClear(), true);
      board.grid[0][0] = 1;
      expect(board.isBoardClear(), false);
    });

    test('hasMoves returns true if a move is possible', () {
      final board = GameBoard(rows: 2, cols: 2, maxValue: 10);
      board.grid = [
        [2, 4],
        [null, null],
      ];
      expect(board.hasMoves(), true);
      board.grid = [
        [null, null],
        [null, null],
      ];
      expect(board.hasMoves(), false);
    });
  });
}
