# Modulo Game

A fun and challenging mobile puzzle game built with Flutter, running on iOS and Android.

## Concept

Modulo is played on a 4x4 grid. Each square can contain a number. Players move numbered squares up, down, left, or right into adjacent squares.

The core mechanic involves the modulo operator:
*   If the **value of the square being moved (`S`)** is **less than or equal to the value of the square it's moved into (`T`)**, a modulo operation occurs: `T % S`.
*   If the remainder of this operation is non-zero, the target square (`T`) is updated with this remainder.
*   If the remainder is zero, the target square (`T`) becomes empty.
*   The source square (`S`) always becomes empty after a valid conditional move.
*   If a square is moved into an empty square, its number simply transfers to the new location.

**The objective of the game is to clear the entire board of numbers.**

## Features

*   Interactive 4x4 game grid.
*   Tap-to-select and tap-to-move mechanics.
*   Core game logic based on the modulo operator.
*   Win condition: Clear all numbers from the board.
*   "New Game" functionality to reset the board.
*   (Planned) Advertising support / Ad-free option.

## How to Play

1.  The game starts with a 4x4 grid partially filled with numbers.
2.  Tap on a numbered square to select it.
3.  Tap on an adjacent square (up, down, left, or right) to attempt a move.
4.  **Move Rules:**
    *   **Moving to an Empty Square:** The selected number moves to the empty square.
    *   **Moving to an Occupied Square:**
        *   Let the selected square's value be `S` and the target square's value be `T`.
        *   If `S <= T`:
            *   The target square becomes `T % S`.
            *   If `T % S == 0`, the target square becomes empty.
            *   The selected square becomes empty.
        *   If `S > T`: The move is not allowed (or the selected square simply empties without affecting the target, depending on final game design choice).
5.  Continue making moves with the goal of clearing all numbers from the grid.
6.  If the board is cleared, you win!
7.  Use the "Refresh" icon in the app bar to start a new game at any time.

## Screenshots / GIFs

*(Add screenshots or a GIF of your game in action here once the UI is more developed!)*

## Tech Stack

*   **Flutter:** For cross-platform (iOS & Android) mobile app development.
*   **Dart:** Programming language used by Flutter.

## Project Structure

A brief overview of the key directories and files:

```
modulo-flutter-project/
├── lib/
│   ├── main.dart               # App entry point, MaterialApp setup
│   ├── models/
│   │   └── game_board.dart     # Core game logic, grid state management
│   ├── screens/
│   │   └── game_screen.dart    # Main UI for the game, handles user interaction
│   └── widgets/
│       └── grid_cell_widget.dart # UI for individual cells in the grid
├── ... (other Flutter project files)
└── README.md                   # This file
```

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: Install Flutter
*   An editor like VS Code or Android Studio with Flutter plugins.

### Installation

1.  Clone the repo:
    ```sh
    git clone <your-repository-url>
    ```
2.  Navigate to the project directory:
    ```sh
    cd modulo-flutter-project
    ```
3.  Install dependencies:
    ```sh
    flutter pub get
    ```
4.  Run the app:
    ```sh
    flutter run
    ```

## Future Enhancements

*   Animations for tile movements and value changes.
*   Sound effects.
*   Levels with predefined starting configurations and increasing difficulty.
*   Scoring system and move counter.
*   Undo move functionality.
*   Integration of banner/interstitial ads (`google_mobile_ads`).
*   In-app purchase option to remove ads (`in_app_purchase`).
*   Persistence of game state.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` file for more information (you'll need to create this file if you want one).

---

Project by: Mark Nelson