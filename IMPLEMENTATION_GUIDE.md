# Implementation Guide: `GameScreen`

**File:** `/Users/marknelson/Circus/modulo-flutter-project/lib/screens/game_screen.dart`

## 1. Overview

The `GameScreen` widget is the primary user interface for the Modulo game. It's a `StatefulWidget` because it needs to manage the changing state of the game, such as the numbers on the grid, the currently selected cell, and the overall game status (e.g., ongoing, won).

It's responsible for:

*   Displaying the 4x4 game grid.
*   Handling user interactions (tapping on cells).
*   Orchestrating game logic by interacting with the `GameBoard` model.
*   Updating the UI based on changes in the game state.
*   Displaying game-related information, like instructions and win/lose messages.

## 2. State Variables

The `_GameScreenState` class holds the following key state variables:

*   `late GameBoard _gameBoard;`
    *   An instance of the `GameBoard` class (from `../models/game_board.dart`).
    *   This object encapsulates all the core game logic: the grid data, move validation, modulo calculations, and checking for win conditions. `GameScreen` delegates game logic operations to `_gameBoard`.
*   `final int _rowCount = 4;`
*   `final int _colCount = 4;`
    *   Constants defining the dimensions of the game grid. These are used to initialize `_gameBoard` and to configure the `GridView.builder`.
*   `int? _selectedRow;`
*   `int? _selectedCol;`
    *   Nullable integers used to keep track of the coordinates (row and column) of the currently selected cell on the grid. If no cell is selected, these are `null`.

## 3. Core Methods and Logic

#### a. Initialization (`initState` and `_startNewGame`)

*   **`initState()`**:
    *   Called once when the widget is inserted into the widget tree.
    *   It initializes `_gameBoard` with the defined `_rowCount` and `_colCount`.
    *   It immediately calls `_startNewGame()` to set up the initial state of the board.
*   **`_startNewGame()`**:
    *   This method is responsible for resetting the game to a new state.
    *   It calls `_gameBoard.populateRandomly(...)` to fill the grid with new random numbers. You can adjust `numbersToPlace` and `maxCellValue` here to control the game's starting difficulty.
    *   It resets `_selectedRow` and `_selectedCol` to `null`, clearing any previous selection.
    *   All these operations are wrapped in `setState(() { ... })` to ensure the UI rebuilds and reflects the new game state.
    *   The commented-out `_gameBoard.printBoard()` is a useful debugging tool to see the board state in the console.

#### b. User Interaction (`_handleCellTap`)

*   This is the heart of the user interaction logic, called whenever a `GridCellWidget` is tapped.
*   It's wrapped in `setState(() { ... })` because nearly every action here can change the visual state of the game.
*   **Logic Flow:**
    1.  **No Cell Selected:** If `_selectedRow` or `_selectedCol` is `null`:
        *   It checks if the tapped cell (`row`, `col`) contains a number (`tappedValue != null`).
        *   If yes, it selects the tapped cell by setting `_selectedRow = row` and `_selectedCol = col`.
    2.  **A Cell is Already Selected:**
        *   **Tapped Same Cell:** If the tapped cell is the one already selected, it deselects it (sets `_selectedRow` and `_selectedCol` to `null`).
        *   **Tapped Different Cell:** This is an attempt to move the selected piece.
            *   It calls `_gameBoard.moveCell(_selectedRow!, _selectedCol!, row, col)`. The `!` (bang operator) is used because we've established `_selectedRow` and `_selectedCol` are not null in this branch.
            *   If `moveSuccessful` is `true`:
                *   It checks `_gameBoard.isBoardClear()`. If true, it calls `_showGameEndDialog` to announce the win.
            *   Regardless of whether the move was successful or not, it **always deselects** the cell (`_selectedRow = null`, `_selectedCol = null`) to prepare for the next selection or to indicate the end of a turn.

#### c. Displaying Game End (`_showGameEndDialog`)

*   A helper method to display an `AlertDialog` when the game is won.
*   It takes a `title` and `message` to customize the dialog.
*   `barrierDismissible: false` prevents the dialog from being closed by tapping outside it.
*   The dialog includes a "Play Again" `TextButton` which, when pressed:
    1.  Pops the dialog (`Navigator.of(context).pop()`).
    2.  Calls `_startNewGame()` to reset the board for a new game.

#### d. Visual Cue for Moves (`_isPossibleTarget`)

*   This method determines if a given `targetRow`, `targetCol` is a valid potential destination for the currently `_selectedRow`, `_selectedCol`.
*   It's used by `GridCellWidget` to visually highlight cells where a move might be possible.
*   **Checks:**
    1.  A cell must be selected.
    2.  The target cannot be the selected cell itself.
    3.  **Adjacency:** The target cell must be strictly horizontal or vertical and one step away from the selected cell.
    4.  **Game Rule:**
        *   The selected cell (`sourceValue`) must have a value.
        *   The move is possible if the `targetValue` is `null` (empty cell) OR if `sourceValue <= targetValue` (the core modulo rule condition).

## 4. UI Construction (`build` method)

The `build` method constructs the visual layout of the game screen:

*   **`Scaffold`**: Provides the basic Material Design visual layout structure.
    *   **`AppBar`**:
        *   Displays the game title "Modulo Game".
        *   Includes an `IconButton` (refresh icon) that calls `_startNewGame()` when pressed.
    *   **`body`**:
        *   A `Center` widget containing a `Column` to arrange elements vertically and centered.
        *   **Instruction Text (`Padding` > `Text`)**:
            *   Displays dynamic instructions based on whether a cell is selected or not.
            *   If a cell is selected, it shows the value and coordinates of the selected cell.
            *   Uses `Theme.of(context).textTheme.titleMedium` for styling.
        *   **Game Grid (`AspectRatio` > `Container` > `GridView.builder`)**:
            *   `AspectRatio(aspectRatio: 1.0)`: Ensures the grid container is always square.
            *   `Container`: Provides padding, margin, and a decorative border around the grid.
            *   `GridView.builder`: Efficiently builds the 4x4 grid.
                *   `physics: const NeverScrollableScrollPhysics()`: Disables scrolling within the grid itself, as it's a fixed size.
                *   `itemCount: _rowCount * _colCount`: Total number of cells.
                *   `gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(...)`: Defines a grid with a fixed number of columns (`_colCount`).
                *   `itemBuilder`: This function is called for each cell in the grid.
                    *   It calculates the `row` and `col` for the current `index`.
                    *   It returns a `GridCellWidget` instance for each cell, passing:
                        *   `value: _gameBoard.getValue(row, col)`: The number in the cell (or null).
                        *   `isSelected: (row == _selectedRow && col == _selectedCol)`: True if this cell is the currently selected one.
                        *   `isPossibleTarget: _isPossibleTarget(row, col)`: True if this cell is a valid move target from the selected cell.
                        *   `onTap: () => _handleCellTap(row, col)`: The callback function when the cell is tapped.
        *   **`TODO` for Ads**: A placeholder comment indicates where an ad banner could be integrated later.

## 5. Dependencies

*   **`../widgets/grid_cell_widget.dart`**: The `GridCellWidget` is used to render each individual cell in the grid. `GameScreen` provides it with the necessary data (value, selection state, tap handler) for it to display correctly.
*   **`../models/game_board.dart`**: The `GameBoard` class is crucial as it holds all the game's rules and state. `GameScreen` acts as a controller, taking user input and instructing `GameBoard` to perform actions and update its state, then re-rendering based on `GameBoard`'s new state.

## 6. Potential Areas for Future Development (as hinted in code)

*   **Ad Integration**: The `TODO` comment suggests plans for adding an ad banner. This would likely involve a package like `google_mobile_ads`.
*   **Animations**: Currently, moves are instantaneous. Adding animations for cell movements, value changes, or cells clearing would greatly enhance the user experience.
*   **Sound Effects**: Audio feedback for actions.
*   **More Sophisticated State Management**: For more complex features or larger game states, consider state management solutions like Provider, Riverpod, or BLoC.
*   **Error Handling/Edge Cases**: While the current logic seems robust for the defined rules, further testing might reveal edge cases in `_handleCellTap` or `_isPossibleTarget` that need addressing.
*   **UI/UX Refinements**:
    *   Clearer visual distinction for "possible target" cells.
    *   More engaging win screen.
    *   Instructions or a tutorial screen.

This guide should provide a comprehensive understanding of how `game_screen.dart` is implemented and functions within the Modulo game application.