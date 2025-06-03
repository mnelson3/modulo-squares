import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/grid_cell_widget.dart';
import '../models/game_board.dart';
import '../constants/app_constants.dart';

/// The main game screen for Modulo.
/// Handles grid rendering, user interaction, and game state.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameBoard _gameBoard;
  static const int _rowCount = 4;
  static const int _colCount = 4;

  int? _selectedRow;
  int? _selectedCol;
  int _moveCount = 0;

  int? _justChangedRow;
  int? _justChangedCol;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _gameBoard = GameBoard(rows: _rowCount, cols: _colCount);
    _startNewGame();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Starts a new game and resets all state.
  void _startNewGame() {
    setState(() {
      final maxValue = GameUtils.calculateMaxValue(difficultyLevel);
      _gameBoard.populateRandomly(numbersToPlace: 7, maxCellValue: maxValue);
      _selectedRow = null;
      _selectedCol = null;
      _moveCount = 0;
      _justChangedRow = null;
      _justChangedCol = null;
    });
  }

  /// Handles tap on a grid cell.
  void _handleCellTap(int row, int col) {
    setState(() {
      if (!mounted) return;
      final tappedValue = _gameBoard.getValue(row, col);

      // Only allow selection if value is not null
      if (_selectedRow == null || _selectedCol == null) {
        if (tappedValue != null) {
          _selectedRow = row;
          _selectedCol = col;
        }
      } else {
        // Ensure selected cell is valid
        final sourceValue = _gameBoard.getValue(_selectedRow!, _selectedCol!);
        if (sourceValue == null) {
          _selectedRow = null;
          _selectedCol = null;
          return;
        }

        if (_selectedRow == row && _selectedCol == col) {
          _selectedRow = null;
          _selectedCol = null;
        } else {
          final moveSuccessful = _gameBoard.moveCell(_selectedRow!, _selectedCol!, row, col);
          if (moveSuccessful) {
            _moveCount++;
            _justChangedRow = row;
            _justChangedCol = col;
            if (_gameBoard.isBoardClear()) {
              _showGameEndDialog(
                title: AppStrings.congratulationsTitle,
                message: AppStrings.boardClearedMessage,
              );
            }
          }
          _selectedRow = null;
          _selectedCol = null;
        }
      }
    });
  }

  /// Shows a dialog when the game ends.
  void _showGameEndDialog({required String title, required String message}) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text(AppStrings.playAgainButton),
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
            ),
          ],
        );
      },
    );
  }

  /// Returns true if the cell at [targetRow], [targetCol] is a possible move target.
  bool _isPossibleTarget(int targetRow, int targetCol) {
    if (_selectedRow == null || _selectedCol == null) return false;
    if (_selectedRow == targetRow && _selectedCol == targetCol) return false;

    // Ensure selected cell is valid
    final sourceValue = _gameBoard.getValue(_selectedRow!, _selectedCol!);
    if (sourceValue == null) return false;

    // Adjacency check
    final isAdjacent = ((_selectedRow == targetRow && (_selectedCol! - targetCol).abs() == 1) ||
        (_selectedCol == targetCol && (_selectedRow! - targetRow).abs() == 1));
    if (!isAdjacent) return false;

    final targetValue = _gameBoard.getValue(targetRow, targetCol);
    return targetValue == null || sourceValue <= targetValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.gameTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
            tooltip: AppStrings.newGameTooltip,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('Some static text'),
            ElevatedButton(
              onPressed: _startNewGame,
              child: const Text('Restart'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _selectedRow != null
                    ? AppStrings.selectedInstruction(
                        _gameBoard.getValue(_selectedRow!, _selectedCol!) ?? 0,
                        _selectedRow!,
                        _selectedCol!)
                    : AppStrings.tapToSelectInstruction,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade200, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _rowCount * _colCount,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _colCount,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ _colCount;
                    final col = index % _colCount;
                    return GridCellWidget(
                      value: _gameBoard.getValue(row, col),
                      isSelected: (row == _selectedRow && col == _selectedCol),
                      isPossibleTarget: _isPossibleTarget(row, col),
                      justChanged: (row == _justChangedRow && col == _justChangedCol),
                      onTap: () => _handleCellTap(row, col),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                AppStrings.movesCount(_moveCount),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            // TODO: Add ad banner here if implementing ads
          ],
        ),
      ),
    );
  }
}
