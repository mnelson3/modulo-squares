
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

