
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'leaderboard_service.dart';

void main() {
  runApp(ModuloApp());
}

class ModuloApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modulo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ModuloGame(),
    );
  }
}

class ModuloGame extends StatefulWidget {
  @override
  _ModuloGameState createState() => _ModuloGameState();
}

class _ModuloGameState extends State<ModuloGame> {
  final Random _random = Random();
  List<List<int?>> grid = [];
  int difficultyLevel = 1; // 1 (easy) to 100 (hard)
  int score = 0;
  int highScore = 0;

  int get gridSize => 4 + ((difficultyLevel - 1) ~/ 10).clamp(0, 6); // From 4x4 to 10x10

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _initializeGrid();
  }

  Future<void> _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  void _initializeGrid() {
    int maxValue = (difficultyLevel * 1000).clamp(1, 100000);
    setState(() {
      grid = List.generate(
        gridSize,
        (_) => List.generate(gridSize, (_) => _random.nextInt(maxValue) + 1),
      );
      score = 0;
    });
  }

  void _move(int row, int col, int dRow, int dCol) {
    int newRow = row + dRow;
    int newCol = col + dCol;

    if (_isInBounds(newRow, newCol)) {
      int? fromValue = grid[row][col];
      int? toValue = grid[newRow][newCol];

      if (fromValue != null && toValue != null && fromValue <= toValue) {
        int result = toValue % fromValue;
        setState(() {
          grid[newRow][newCol] = result != 0 ? result : null;
          grid[row][col] = null;
          score += 1;
          if (score > highScore) {
            highScore = score;
            _saveHighScore();
          }
        });
        _checkWinLose();
      }
    }
  }

  bool _isInBounds(int row, int col) {
    return row >= 0 && row < gridSize && col >= 0 && col < gridSize;
  }

  void _checkWinLose() {
    bool isWin = grid.every((row) => row.every((cell) => cell == null));
    if (isWin) {
      _showEndDialog('You Win!', 'Congratulations, you cleared the board! Score: \$score');
      return;
    }

    // Check for possible moves
    bool hasMoves = false;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        int? current = grid[i][j];
        if (current == null) continue;
        for (var dir in [
          [-1, 0], [1, 0], [0, -1], [0, 1]
        ]) {
          int ni = i + dir[0];
          int nj = j + dir[1];
          if (_isInBounds(ni, nj) && grid[ni][nj] != null && current <= grid[ni][nj]!) {
            hasMoves = true;
            break;
          }
        }
        if (hasMoves) break;
      }
      if (hasMoves) break;
    }

    if (!hasMoves) {
      _showEndDialog('Game Over', 'No more valid moves available. Score: \$score');
    }
  }

  void _showEndDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            SizedBox(height: 16),
            if (title == 'You Win!' || title == 'Game Over')
              _ScoreSubmissionWidget(onSubmit: (name) {
                LeaderboardService.submitScore(name, score);
                Navigator.of(context).pop(); // close dialog
              }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeGrid();
            },
            child: Text('Play Again'),
          )
        ],
      ),
    );
  }

  void _showLeaderboardDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Leaderboard - Top Scores'),
        content: Container(
          width: double.maxFinite,
          child: LeaderboardService.buildLeaderboardWidget(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(gridSize, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(gridSize, (col) {
            return GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    _move(row, col, -1, 0); // Up
                  } else if (details.primaryVelocity! > 0) {
                    _move(row, col, 1, 0); // Down
                  }
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < 0) {
                    _move(row, col, 0, -1); // Left
                  } else if (details.primaryVelocity! > 0) {
                    _move(row, col, 0, 1); // Right
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.all(2),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: grid[row][col] != null ? Colors.blue[300] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  grid[row][col]?.toString() ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildDifficultySlider() {
    return Column(
      children: [
        Text('Difficulty Level: \$difficultyLevel', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: difficultyLevel.toDouble(),
          min: 1,
          max: 100,
          divisions: 99,
          label: difficultyLevel.toString(),
          onChanged: (double value) {
            setState(() {
              difficultyLevel = value.toInt();
              _initializeGrid();
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modulo'),
        actions: [
          IconButton(
            icon: Icon(Icons.leaderboard),
            onPressed: _showLeaderboardDialog,
            tooltip: 'Show Leaderboard',
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDifficultySlider(),
          SizedBox(height: 20),
          Text('Score: \$score  High Score: \$highScore', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Center(child: _buildGrid()),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _initializeGrid,
            child: Text('Restart'),
          )
        ],
      ),
    );
  }
}

class _ScoreSubmissionWidget extends StatefulWidget {
  final Function(String) onSubmit;
  _ScoreSubmissionWidget({required this.onSubmit});

  @override
  __ScoreSubmissionWidgetState createState() => __ScoreSubmissionWidgetState();
}

class __ScoreSubmissionWidgetState extends State<_ScoreSubmissionWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(labelText: 'Enter your name'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onSubmit(_controller.text.trim());
            }
          },
          child: Text('Submit Score'),
        )
      ],
    );
  }
}
