// /Users/marknelson/Circus/modulo-flutter-project/lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/grid_cell_widget.dart';
import '../models/game_board.dart';
import '../src/constants/app_constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameBoard _gameBoard; // Declare _gameBoard here
  final int _rowCount = 4;
  final int _colCount = 4;

  // To track selected cell for movement
  int? _selectedRow;
  int? _selectedCol;
  int _moveCount = 0;

  // For visual feedback on changed cell
  int? _justChangedRow;
  int? _justChangedCol;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState(); // Call super.initState() first
    _gameBoard = GameBoard(rows: _rowCount, cols: _colCount);
    _startNewGame();
    // Preload sounds if desired, or handle errors if files are missing
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Correctly placed in State class
    super.dispose();
  }

  Future<void> _playSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // ignore: avoid_print
      print("Error playing sound $assetPath: $e");
    }
  }

  void _startNewGame() {
    setState(() {
      // If _gameBoard is not initialized here, ensure it's done in initState
      if (!mounted) return; // Check if widget is still mounted

      _gameBoard.populateRandomly(
          numbersToPlace: 7, maxCellValue: 25); // Adjust as needed
      _selectedRow = null;
      _selectedCol = null;
      _moveCount = 0;
      _justChangedRow = null;
      _justChangedCol = null;
      // _gameBoard.printBoard(); // For debugging
    });
  }

  void _handleCellTap(int row, int col) {
    setState(() {
      int? tappedValue = _gameBoard.getValue(row, col);
      if (!mounted) return;

      if (_selectedRow == null || _selectedCol == null) {
        // No cell selected yet: select this one if it has a number
        if (tappedValue != null) {
          _selectedRow = row;
          _selectedCol = col;
        }
      } else {
        // A cell is already selected (_selectedRow, _selectedCol)
        if (_selectedRow == row && _selectedCol == col) {
          // Tapped the same selected cell: deselect
          _selectedRow = null;
          _selectedCol = null;
        } else {
          // Tapped a different cell: attempt to move
          bool moveSuccessful = _gameBoard.moveCell(
            _selectedRow!,
            _selectedCol!,
            row,
            col,
          );

          if (moveSuccessful) {
            // _gameBoard.printBoard(); // For debugging
            if (_gameBoard.isBoardClear()) {
              _showGameEndDialog(
                  // Using AppStrings for consistency, assuming it's available
                  title: AppStrings.congratulationsTitle,
                  message: AppStrings.boardClearedMessage);
            }
          }
          // Always deselect after a move attempt (successful or not)
          _selectedRow = null;
          _selectedCol = null;
        }
      }
    });
  }

  void _showGameEndDialog({required String title, required String message}) {
    showDialog(
      // Ensure context is valid and widget is mounted if this can be called asynchronously
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

  bool _isPossibleTarget(int targetRow, int targetCol) {
    if (_selectedRow == null || _selectedCol == null) return false;
    if (_selectedRow == targetRow && _selectedCol == targetCol) {
      return false; // Cannot be target of itself
    }

    // Check adjacency
    bool isAdjacent = ((_selectedRow == targetRow &&
            (_selectedCol! - targetCol).abs() == 1) ||
        (_selectedCol == targetCol && (_selectedRow! - targetRow).abs() == 1));
    if (!isAdjacent) return false;

    // Check game rule: source <= target OR target is empty
    int? sourceValue = _gameBoard.getValue(_selectedRow!, _selectedCol!);
    int? targetValue = _gameBoard.getValue(targetRow, targetCol);

    if (sourceValue == null) {
      return false; // Should not happen if selection logic is correct
    }

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
            // Consider adding Undo button here if implemented
          )
        ],
      ),
      body: Center(
        // Center the grid and instructions
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _selectedRow != null
                    ? AppStrings.selectedInstruction(
                        _gameBoard.getValue(_selectedRow!, _selectedCol!) ??
                            0, // Handle null case for value
                        _selectedRow!,
                        _selectedCol!)
                    : AppStrings.tapToSelectInstruction,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            AspectRatio(
              aspectRatio: 1.0, // Makes the GridView square
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(16.0), // Margin around the grid
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade200, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _rowCount * _colCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _colCount,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ _colCount;
                    int col = index % _colCount;
                    return GridCellWidget(
                      value: _gameBoard.getValue(row, col),
                      isSelected: (row == _selectedRow && col == _selectedCol),
                      isPossibleTarget: _isPossibleTarget(row, col),
                      // justChanged: (row == _justChangedRow && col == _justChangedCol), // Assuming _justChangedRow/Col are managed
                      onTap: () => _handleCellTap(row, col),
                    );
                  },
                ),
              ),
            ),
            // Display move count
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                AppStrings.movesCount(_moveCount),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            // TODO: Add ad banner here if implementing ads
            // Example: if (_adsEnabled) Container(height: 50, child: AdWidgetPlaceholder())
          ],
        ),
      ),
    );
  }
}
