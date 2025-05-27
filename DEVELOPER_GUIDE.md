# Modulo Game - Developer Guide

This guide provides information for developers looking to contribute to or understand the technical aspects of the Modulo Game project.

## 1. Introduction

*   Brief overview of the project (can reference `README.md` for game concept).
*   Purpose of this developer guide.

## 2. Development Environment Setup

*   **Flutter SDK:**
    *   Link to official Flutter installation guide.
    *   Recommended Flutter version/channel (e.g., stable).
*   **IDE Setup:**
    *   Recommended IDEs (VS Code, Android Studio).
    *   Essential plugins/extensions (e.g., Flutter, Dart for VS Code).
*   **Platform Specific Setup:**
    *   iOS (Xcode, CocoaPods).
    *   Android (Android Studio, Android SDK, NDK if applicable).
*   **Cloning and Initial Setup:**
    *   `git clone <repository-url>`
    *   `flutter pub get`
    *   Running the app: `flutter run`
    *   Checking project health: `flutter doctor`

## 3. Project Architecture

*   **Overall Structure:**
    *   Brief explanation of the `lib/` subdirectories (`models`, `screens`, `widgets`, `main.dart`).
    *   Mention any other important directories (e.g., `assets`, `test`).
*   **State Management:**
    *   Current approach (e.g., `setState` for local widget state).
    *   (If applicable) Plans or considerations for more advanced state management (Provider, Riverpod, BLoC) as the app grows.
*   **Key Components & Responsibilities:**
    *   `main.dart`: App initialization, root widget (`ModuloApp`), theme.
    *   `models/game_board.dart`: Core game logic, data representation, rules engine.
    *   `screens/game_screen.dart`: Main UI, user interaction handling, orchestrates `GameBoard`.
    *   `widgets/grid_cell_widget.dart`: UI for individual grid cells.
*   **Data Flow:**
    *   How user input translates to game state changes.
    *   How `GameBoard` updates propagate to the UI.

## 4. Coding Conventions & Style

*   **Dart & Flutter Style:**
    *   Adherence to the official Dart style guide.
    *   Effective Dart guidelines.
    *   Flutter linting rules (e.g., using `flutter_lints` or a custom `analysis_options.yaml`).
*   **Naming Conventions:**
    *   `UpperCamelCase` for classes and enums.
    *   `lowerCamelCase` for variables, methods, and parameters.
    *   `snake_case` for file names (e.g., `game_screen.dart`).
*   **Comments:**
    *   Use `//` for single-line comments.
    *   Use `///` for documentation comments (for classes, methods, etc.) that can be processed by `dart doc`.
*   **Widget Structure:**
    *   Prefer `const` constructors where possible.
    *   Break down large `build` methods into smaller private methods or separate widgets.

## 5. Testing

*   **Types of Tests:**
    *   **Unit Tests:** For testing individual functions, methods, or classes (especially in `models/game_board.dart`).
        *   Location: `test/unit_tests/`
    *   **Widget Tests:** For testing individual widgets in isolation.
        *   Location: `test/widget_tests/`
    *   **Integration Tests (Planned/Future):** For testing complete app flows.
        *   Location: `test_driver/` or `integration_test/`
*   **Running Tests:**
    *   `flutter test` (for unit and widget tests).
    *   `flutter test integration_test` (if using the `integration_test` package).
*   **Writing Tests:**
    *   Brief guidelines on how to add new tests.

## 6. Version Control (Git)

*   **Branching Strategy (Example):**
    *   `main` (or `master`): Production-ready code.
    *   `develop`: Integration branch for features.
    *   Feature branches: `feature/<feature-name>` (e.g., `feature/add-animations`).
    *   Bugfix branches: `fix/<issue-description>` (e.g., `fix/incorrect-modulo-calc`).
*   **Commit Messages:**
    *   Follow conventional commit message format (e.g., `feat: Implement new game mechanic`).
*   **Pull Requests (PRs):**
    *   Guidelines for creating PRs (e.g., link to issue, clear description, self-review).

## 7. Building and Releasing

*   **Android:**
    *   Generating a signed APK/AAB: `flutter build apk --release`, `flutter build appbundle --release`.
    *   Key store management.
*   **iOS:**
    *   Building for release: `flutter build ipa --release`.
    *   Code signing and provisioning profiles.
*   **Version Numbering:**
    *   How `pubspec.yaml` version (`version: 1.0.0+1`) is handled.

## 8. Debugging

*   **Flutter DevTools:** Overview of using DevTools for layout inspection, performance profiling, etc.
*   **Logging:** Using `print()` for simple debugging or a more robust logging package.
*   **Breakpoints:** Using IDE debuggers.

## 9. Future Development & Roadmap

*   Reference the "Future Enhancements" section in `README.md`.
*   Any specific architectural considerations for upcoming features.

## 10. Contact & Contribution

*   How to get in touch (e.g., GitHub issues).
*   Reiterate contribution guidelines from `README.md`.

# Developer Guide

## Project Structure
- `lib/main.dart`: Core game logic, UI, and integration of leaderboard UI.
- `lib/leaderboard_service.dart`: Handles Firebase Firestore communication for leaderboard data.
- `pubspec.yaml`: Flutter dependencies and project config.

## Important Classes
- `ModuloGame`: Main game widget with grid, gestures, scoring, and difficulty.
- `LeaderboardService`: Static service for submitting and fetching leaderboard scores.

## State Management
- Uses simple `setState` for state updates in `StatefulWidget`.
- Scores are saved locally using `SharedPreferences`.
- Leaderboard data is fetched live from Firestore using `StreamBuilder`.

## Firebase Integration
- Requires initialization of Firebase in your Flutter app (not included here, refer to Firebase setup docs).
- Firestore stores scores with player names as document IDs in collection `modulo_leaderboard`.

