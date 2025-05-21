
# Modulo Game

A mobile puzzle game for iOS and Android built with Flutter. The game features a grid of numbers where players move tiles using modulo arithmetic to clear the board. It includes local high score tracking and a global leaderboard powered by Firebase Firestore.

---

## Features
- Variable grid size from 4x4 up to 10x10 depending on difficulty.
- Score tracking and local high score persistence.
- Global leaderboard synced with Firebase Firestore.
- Easy-to-hard difficulty scaling with random number ranges.
- Swipe gestures for tile movement.

---

## Setup Instructions

### Prerequisites
- Flutter SDK installed (>=2.17.0)
- Firebase project created for iOS and Android apps
- Firebase CLI installed

### Steps
1. Clone or unzip this project folder.
2. Run `flutter pub get` to install dependencies.
3. Follow Firebase setup:
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files to the project as per Firebase instructions.
   - Enable Firestore in your Firebase console.
4. Run `flutter run` to start the app on a simulator or physical device.

### Notes
- The leaderboard requires an internet connection.
- Firestore rules should allow read/write access to the `modulo_leaderboard` collection for this demo or implement security rules as needed.

