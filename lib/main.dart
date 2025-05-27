import 'package:flutter/material.dart';

void main() {
  runApp(const ModuloApp());
}

class ModuloApp extends StatelessWidget {
  const ModuloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Modulo Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int gridSize = 4;
  List<List<int?>> grid = [];

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid() {
    grid = List.generate(gridSize,
        (_) => List.generate(gridSize, (_) => _randomValue()));
  }

  int _randomValue() => 1 + (10 + (100 * gridSize)) ~/ gridSize;

  void _move(int dx, int dy) {
    setState(() {
      for (int row = (dy > 0 ? gridSize - 2 : 1);
          dy != 0 && row >= 0 && row < gridSize;
          row += (dy > 0 ? -1 : 1)) {
        for (int col = 0; col < gridSize; col++) {
          _tryMove(row, col, dx, dy);
        }
      }

      for (int col = (dx > 0 ? gridSize - 2 : 1);
          dx != 0 && col >= 0 && col < gridSize;
          col += (dx > 0 ? -1 : 1)) {
        for (int row = 0; row < gridSize; row++) {
          _tryMove(row, col, dx, dy);
        }
      }
    });
  }

  void _tryMove(int row, int col, int dx, int dy) {
    int newRow = row + dy;
    int newCol = col + dx;
    if (newRow < 0 || newRow >= gridSize || newCol < 0 || newCol >= gridSize) {
      return;
    }

    int? source = grid[row][col];
    int? dest = grid[newRow][newCol];

    if (source == null || dest == null) return;
    if (source <= dest) {
      int result = dest % source;
      grid[newRow][newCol] = result == 0 ? null : result;
      grid[row][col] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modulo Game"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _initializeGrid());
            },
          )
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _move(1, 0);
          } else {
            _move(-1, 0);
          }
        },
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _move(0, 1);
          } else {
            _move(0, -1);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: gridSize * gridSize,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final row = index ~/ gridSize;
              final col = index % gridSize;
              final value = grid[row][col];
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: value == null ? Colors.grey[300] : Colors.blue[100],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value?.toString() ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
