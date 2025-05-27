// /Users/marknelson/Circus/modulo-flutter-project/lib/src/constants/app_constants.dart

class AppStrings {
  static const String gameTitle = 'Modulo Game';
  static const String newGameTooltip = 'New Game';
  static const String undoMoveTooltip = 'Undo Move';

  static const String tapToSelectInstruction =
      'Tap a numbered square to select it.';
  static String selectedInstruction(int value, int row, int col) =>
      'Selected ($value) at [$row, $col]. Tap an adjacent cell to move.';

  static const String congratulationsTitle = 'Congratulations!';
  static const String boardClearedMessage = 'You cleared the board!';
  static const String gameOverTitle = 'Game Over';
  static const String noMoreMovesMessage = 'No more possible moves!';
  static const String playAgainButton = 'Play Again';

  static String movesCount(int count) => 'Moves: $count';
}
