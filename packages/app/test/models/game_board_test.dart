import 'package:flutter_test/flutter_test.dart';
import 'package:modulo/shared/models/game_board.dart';

void main() {
  group('GameBoard', () {
    test('initializes with correct size and non-null values', () {
      final board = GameBoard(level: 1);
      expect(board.grid.length, 4);
      expect(board.grid[0].length, 4);
      // All cells should be Tile, and most should have value != null
      expect(board.grid.expand((row) => row).where((cell) => cell.value != null || cell.type != TileType.normal).length, 16);
    });

    test('move returns null for out-of-bounds', () {
      final board = GameBoard(level: 1);
      expect(board.move(-1, 0, 1, 0), null);
      expect(board.move(0, -1, 0, 1), null);
      expect(board.move(4, 0, 1, 0), null);
      expect(board.move(0, 4, 0, 1), null);
    });

    test('reset clears score and reinitializes grid', () {
      var board = GameBoard(level: 1);
      board = board.copyWith(score: 5);
      board = board.reset();
      expect(board.score, 0);
      expect(board.grid.length, 4);
      expect(board.grid[0].length, 4);
    });

    test('isBoardClear returns true only if all cells are empty', () {
      var board = GameBoard(level: 1);
      board = board.copyWith(
        grid: [
          [const Tile(), const Tile()],
          [const Tile(), const Tile()],
        ],
      );
      expect(board.isBoardClear(), true);

      board = board.copyWith(
        grid: [
          [const Tile(value: 1), const Tile()],
          [const Tile(), const Tile()],
        ],
      );
      expect(board.isBoardClear(), false);
    });

    test('hasMoves returns true if a move is possible', () {
      // Positive case: an empty adjacent cell allows a move
      var board = GameBoard.fromGrid(
        rows: 2,
        cols: 2,
        maxValue: 10,
        grid: const [
          [Tile(value: 4), Tile(value: 2)],
          [Tile(), Tile()],
        ],
      );
      expect(board.hasMoves(), true);

      // Negative case: obstacles block all possible moves
      board = GameBoard.fromGrid(
        rows: 2,
        cols: 2,
        maxValue: 10,
        grid: const [
          [Tile(value: 5), Tile(type: TileType.obstacle)],
          [Tile(type: TileType.obstacle), Tile(value: 2)],
        ],
      );
      expect(board.hasMoves(), false);
    });
  });
}
