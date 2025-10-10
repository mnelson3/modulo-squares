import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modulo/shared/models/game_board.dart';
import 'package:modulo/shared/models/cell_position.dart';
import 'package:modulo/shared/widgets/grid_cell_widget.dart';
import 'package:modulo/core/services/leaderboard_service.dart';
import 'package:modulo/l10n/app_localizations.dart';
import 'package:modulo/features/game/instructions_screen.dart';
import 'package:modulo/core/services/analytics_service.dart';
import 'package:modulo/core/services/ad_service.dart';
import 'package:modulo/core/services/purchase_service.dart';
import 'package:modulo/core/di/service_locator.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameBoard gameBoard;
  int level = 1;
  int highScore = 0;
  int remainingMoves = 40;
  CellPosition? selectedCell;

  // Services from dependency injection
  late final AnalyticsService _analyticsService;
  late final AdService _adService;
  late final PurchaseService _purchaseService;

  @override
  void initState() {
    super.initState();

    // Initialize services from dependency injection
    _analyticsService = getIt<AnalyticsService>();
    _adService = getIt<AdService>();
    _purchaseService = getIt<PurchaseService>();

    _loadHighScore();
    _initializeGameBoard();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  void _initializeGameBoard() {
    setState(() {
      gameBoard = GameBoard(level: level);
      selectedCell = null;
      remainingMoves = 20 + (level - 1) * 2;
    });
    _analyticsService.logLevelStart(level: level, rows: gameBoard.rows, cols: gameBoard.cols);
  }

  void _handleTap(int row, int col) {
    setState(() {
      if (selectedCell == null) {
        selectedCell = CellPosition(row, col);
      } else {
        final int dRow = row - selectedCell!.row;
        final int dCol = col - selectedCell!.col;
        if ((dRow.abs() == 1 && dCol == 0) || (dRow == 0 && dCol.abs() == 1)) {
          _move(selectedCell!.row, selectedCell!.col, dRow, dCol);
        }
        selectedCell = null;
      }
    });
  }

  void _move(int row, int col, int dRow, int dCol) {
    setState(() {
      if (remainingMoves <= 0) return;
      final newBoard = gameBoard.move(row, col, dRow, dCol);
      if (newBoard != null) {
        gameBoard = newBoard;
        remainingMoves--;
        _analyticsService.logMove(type: 'tap');
        // Mercy spawn: if exactly one tile remains and we still have moves, spawn helper
        if (gameBoard.nonEmptyTileCount() == 1 && remainingMoves > 0) {
          final maybe = gameBoard.mercySpawnHelperTile(scorePenalty: 5);
          if (maybe != null) {
            gameBoard = maybe;
            remainingMoves--; // cost one extra move for mercy spawn
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).mercyHelperSpawned(5))),
            );
            _analyticsService.logMercySpawn(penalty: 5);
          }
        }
        if (gameBoard.score > highScore) {
          highScore = gameBoard.score;
          _saveHighScore();
        }
        _checkWinLose();
      }
    });
  }

  void _slide(int row, int col, int dRow, int dCol) {
    setState(() {
      if (remainingMoves <= 0) return;
      final newBoard = gameBoard.slide(row, col, dRow, dCol);
      if (newBoard != null) {
        gameBoard = newBoard;
        remainingMoves--;
        _analyticsService.logMove(type: 'swipe');
        // Mercy spawn: if exactly one tile remains and we still have moves, spawn helper
        if (gameBoard.nonEmptyTileCount() == 1 && remainingMoves > 0) {
          final maybe = gameBoard.mercySpawnHelperTile(scorePenalty: 5);
          if (maybe != null) {
            gameBoard = maybe;
            remainingMoves--; // cost one extra move for mercy spawn
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).mercyHelperSpawned(5))),
            );
            _analyticsService.logMercySpawn(penalty: 5);
          }
        }
        if (gameBoard.score > highScore) {
          highScore = gameBoard.score;
          _saveHighScore();
        }
        _checkWinLose();
      }
    });
  }

  void _checkWinLose() {
    if (gameBoard.isBoardClear()) {
      // Show ad, then level up and show dialog
      _adService.showInterstitial(
          trigger: 'level_complete',
          levelNum: level,
          onClosed: () {
            setState(() {
              level++;
            });
            _analyticsService.logLevelComplete(level: level - 1, score: gameBoard.score);
            _showEndDialog(
              'Level Complete!',
              'You cleared the board! Proceeding to level $level.',
              false,
            );
          });
      return;
    }
    if (remainingMoves <= 0) {
      _analyticsService.logOutOfMoves(level: level, score: gameBoard.score);
      _showEndDialog(
        'Out of Moves',
        'No more moves left. Try again!',
        false,
      );
      return;
    }
    if (!gameBoard.hasMoves()) {
      _analyticsService.logGameOverNoMoves(score: gameBoard.score);
      _showEndDialog(
        AppLocalizations.of(context).gameOver,
        AppLocalizations.of(context).gameOverMessage(gameBoard.score),
        true,
      );
    }
  }

  void _showEndDialog(String title, String message, bool showLeaderboardOption) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLeaderboardDialog() {
    _analyticsService.logViewLeaderboard();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).globalLeaderboard),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: LeaderboardService.getTopScores(10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context).noScoresYet),
                  );
                }
                final scores = snapshot.data!;
                return ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (_, index) {
                    final item = scores[index];
                    return ListTile(
                      leading: Text('#${index + 1}'),
                      title: Text(item['name']),
                      trailing: Text(item['score'].toString()),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).close),
            ),
          ],
        );
      },
    );
  }

  void _showTileEffectInfo(Tile tile) {
    String effect = '';
    switch (tile.type) {
      case TileType.obstacle:
        effect = AppLocalizations.of(context).obstacleTooltip;
        break;
      case TileType.bonus:
        effect = AppLocalizations.of(context).bonusTooltip;
        break;
      case TileType.normal:
        return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(effect),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSpecialTilesInfo() {
    _analyticsService.logSpecialTilesInfo();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).specialTilesTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.block, color: Colors.black87),
                title: Text(AppLocalizations.of(context).obstacleTitle),
                subtitle: Text(AppLocalizations.of(context).obstacleSubtitle),
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.green),
                title: Text(AppLocalizations.of(context).bonusTitle),
                subtitle: Text(AppLocalizations.of(context).bonusSubtitle),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).close),
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Ads'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_purchaseService.adsRemoved)
                const ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text('Ads Removed'),
                  subtitle: Text('You have successfully removed ads!'),
                )
              else
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.orange),
                  title: const Text('Remove Ads'),
                  subtitle: Text('Price: ${_purchaseService.getProductPrice('remove_ads')}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      try {
                        await _purchaseService.purchaseAdRemoval();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchase completed! Ads removed.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Purchase failed: $e')),
                        );
                      }
                    },
                    child: const Text('Buy'),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await _purchaseService.restorePurchases();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Purchase restoration attempted.')),
                  );
                },
                child: const Text('Restore Purchases'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLevelInfo() {
    return Column(
      children: [
        Text('Level: $level', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('Moves left: $remainingMoves', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gameBoard.cols,
        ),
        itemBuilder: (context, index) {
          final row = index ~/ gameBoard.cols;
          final col = index % gameBoard.cols;
          Offset? dragStart;
          final tile = gameBoard.grid[row][col];
          return GestureDetector(
            onTap: () {
              _handleTap(row, col);
              if (tile.type != TileType.normal) {
                _showTileEffectInfo(tile);
              }
            },
            onPanStart: (details) {
              dragStart = details.localPosition;
            },
            onPanUpdate: (details) {
              // no-op
            },
            onPanEnd: (details) {
              if (dragStart == null) return;
              final velocity = details.velocity.pixelsPerSecond;
              int dRow = 0;
              int dCol = 0;
              if (velocity.distanceSquared > 1000) {
                if (velocity.dx.abs() > velocity.dy.abs()) {
                  dCol = velocity.dx > 0 ? 1 : -1;
                } else {
                  dRow = velocity.dy > 0 ? 1 : -1;
                }
              } else {
                return;
              }
              _slide(row, col, dRow, dCol);
            },
            child: GridCellWidget(
              tile: tile,
              isSelected: selectedCell?.row == row && selectedCell?.col == col,
            ),
          );
        },
        itemCount: gameBoard.rows * gameBoard.cols,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: _showLeaderboardDialog,
            tooltip: AppLocalizations.of(context).showLeaderboard,
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () {
              _analyticsService.logViewInstructions();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InstructionsScreen()),
              );
            },
            tooltip: AppLocalizations.of(context).howToPlay,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showSpecialTilesInfo,
            tooltip: 'Special Tiles Info',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _showPurchaseDialog,
            tooltip: 'Remove Ads',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLevelInfo(),
          const SizedBox(height: 20),
          Text(
            '${AppLocalizations.of(context).score} ${gameBoard.score} ${AppLocalizations.of(context).highScore} $highScore',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Center(child: _buildGrid()),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              _adService.showInterstitial(trigger: 'restart', levelNum: level, onClosed: _initializeGameBoard);
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }
}
