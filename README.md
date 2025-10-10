# Modulo Squares Monorepo

A Firebase-powered puzzle game built with Flutter, featuring in-app purchases and cross-platform support.

## Project Structure

```
modulo-monorepo/
├── packages/
│   ├── app/                    # Flutter mobile/web app
│   │   ├── lib/               # Flutter source code
│   │   ├── android/           # Android platform code
│   │   ├── ios/               # iOS platform code
│   │   ├── web/               # Web platform code
│   │   └── pubspec.yaml       # Flutter dependencies
│   ├── functions/             # Firebase Cloud Functions (API server)
│   │   ├── index.js          # Cloud Functions code
│   │   └── package.json      # Node.js dependencies
│   ├── firestore-rules/       # Firestore security rules
│   │   └── firestore.rules   # Database security rules
│   └── shared/               # Shared code and utilities
├── firebase.json             # Firebase configuration
├── .firebaserc              # Firebase project configuration
└── package.json             # Monorepo root configuration
```

## Packages

### App (`packages/app/`)
The main Flutter application with cross-platform support for mobile and web.

**Tech Stack:**
- Flutter 3.32.0
- Firebase (Auth, Firestore, Analytics, Functions)
- Google Mobile Ads
- In-App Purchases

### Functions (`packages/functions/`)
Firebase Cloud Functions serving as the API server.

**Features:**
- Score submission validation
- Leaderboard management
- Purchase validation
- Server-side business logic

### Firestore Rules (`packages/firestore-rules/`)
Security rules for Firestore database access control.

## Game Concept

Modulo is played on a 4x4 grid. Each square can contain a number. Players move numbered squares up, down, left, or right into adjacent squares.

The core mechanic involves the modulo operator:
*   If the **value of the square being moved (`S`)** is **less than or equal to the value of the square it's moved into (`T`)**, a modulo operation occurs: `T % S`.
*   If the remainder of this operation is non-zero, the target square (`T`) is updated with this remainder.
*   If the remainder is zero, the target square (`T`) becomes empty.
*   The source square (`S`) always becomes empty after a valid conditional move.
*   If a square is moved into an empty square, its number simply transfers to the new location.

**The objective of the game is to clear the entire board of numbers.**

## Development

### Prerequisites
- Flutter 3.32.0+
- Node.js 18+
- Firebase CLI
- Android Studio (for Android development)
- Xcode (for iOS development)

### Setup
```bash
# Install root dependencies
npm install

# Install functions dependencies
npm run install:all

# Login to Firebase
firebase login
```

### Development Commands
```bash
# Run Flutter app
cd packages/app && flutter run

# Run functions locally
firebase emulators:start

# Test Flutter app
npm run test:app

# Deploy all services
npm run deploy:all
```

### Building
```bash
# Build Android APK
npm run build:app

# Build web app
cd packages/app && flutter build web
```

## Deployment

The project uses Firebase for hosting and backend services:

- **Flutter Web App**: Deployed to Firebase Hosting
- **Cloud Functions**: Serverless API endpoints
- **Firestore**: NoSQL database with security rules
- **Authentication**: Firebase Auth for user management

## Architecture

- **Monorepo Structure**: Organized packages for better code separation
- **Firebase Backend**: Functions as API server, Firestore for data
- **Cross-Platform**: Single Flutter codebase for mobile and web
- **Monetization**: In-app purchases for ad removal
- **Analytics**: Firebase Analytics for user behavior tracking

## Screenshots / GIFs

*(Add screenshots or a GIF of your game in action here once the UI is more developed!)*

## Tech Stack

*   **Flutter:** For cross-platform (iOS & Android) mobile app development.
*   **Dart:** Programming language used by Flutter.
*   **Firebase:** Backend services for authentication, analytics, and data storage.
*   **Google Mobile Ads:** Advertising integration with consent management.
*   **GetIt:** Dependency injection for better testability and architecture.

## Architecture

This project follows a **feature-based architecture** with clear separation of concerns:

```
lib/
├── core/                          # Application-wide services and configuration
│   ├── config/
│   │   └── firebase_options.dart  # Firebase platform-specific configuration
│   ├── di/
│   │   └── service_locator.dart   # Dependency injection setup
│   └── services/                  # Core services (analytics, ads, consent, leaderboard)
│       ├── ad_service.dart
│       ├── analytics_service.dart
│       ├── consent_service.dart
│       ├── game_utils.dart
│       └── leaderboard_service.dart
├── features/                      # Feature-specific code
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer (repositories, datasources, models)
│   │   ├── domain/                # Domain layer (entities, repositories, usecases)
│   │   ├── login_screen.dart
│   │   └── profile_screen.dart
│   ├── game/                      # Game feature
│   │   ├── game_screen.dart       # Main game UI
│   │   └── instructions_screen.dart
│   └── leaderboard/               # Leaderboard feature
│       └── leaderboard_screen.dart
├── shared/                        # Shared components across features
│   ├── models/                    # Common data models
│   │   ├── cell_position.dart
│   │   ├── game_board.dart
│   │   └── user_profile_model.dart
│   └── widgets/                   # Reusable UI components
│       └── grid_cell_widget.dart
├── l10n/                          # Localization files
├── main.dart                      # App entry point
└── firebase_options.dart          # Legacy Firebase config (deprecated)
```

### Architecture Principles

- **Feature-based:** Code is organized by features rather than technical layers
- **Dependency Injection:** Services are injected using GetIt for better testability
- **Clean Architecture:** Separation between data, domain, and presentation layers
- **Shared Components:** Common models and widgets are centralized
- **Firebase-first:** Backend services integrated throughout the application

## Project Structure

A brief overview of the key directories and files:

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: Install Flutter
*   An editor like VS Code or Android Studio with Flutter plugins.
*   Firebase project: Set up a Firebase project for authentication, Firestore, and Analytics.

### Firebase Setup

1.  Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)
2.  Enable Authentication with Anonymous sign-in
3.  Enable Firestore Database
4.  Enable Google Analytics
5.  Add Android and iOS apps to your Firebase project
6.  Download and place the configuration files:
    - `google-services.json` in `android/app/`
    - `GoogleService-Info.plist` in `ios/Runner/`

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

### Testing

Run the test suite:
```sh
flutter test
```

Run with code coverage:
```sh
flutter test --coverage
```

## Future Enhancements

*   Enhanced animations for tile movements and value changes.
*   Sound effects and haptic feedback.
*   More special tile types and power-ups.
*   Daily challenges and tournaments.
*   Social features (friend leaderboards, achievements).
*   Cloud save functionality for cross-device progress.
*   Advanced analytics and player behavior insights.
*   A/B testing framework for game balance.
*   Offline mode with local leaderboards.

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