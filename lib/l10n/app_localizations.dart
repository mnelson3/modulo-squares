import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get appTitle => Intl.message('Modulo', name: 'appTitle');
  String get profile => Intl.message('Profile', name: 'profile');
  String get signOut => Intl.message('Sign Out', name: 'signOut');
  String get name => Intl.message('Name', name: 'name');
  String get email => Intl.message('Email', name: 'email');
  String get uid => Intl.message('UID', name: 'uid');
  String get difficultyLevel => Intl.message('Difficulty Level:', name: 'difficultyLevel');
  String get score => Intl.message('Score:', name: 'score');
  String get highScore => Intl.message('High Score:', name: 'highScore');
  String get restart => Intl.message('Restart', name: 'restart');
  String get youWin => Intl.message('You Win!', name: 'youWin');
  String winMessage(int score) => Intl.message(
        'Congratulations, you cleared the board! Score: $score',
        name: 'winMessage',
        args: [score],
        examples: const {'score': 42},
      );
  String get gameOver => Intl.message('Game Over', name: 'gameOver');
  String gameOverMessage(int score) => Intl.message(
        'No more valid moves available. Score: $score',
        name: 'gameOverMessage',
        args: [score],
        examples: const {'score': 42},
      );
  String get enterName => Intl.message('Enter your name to submit score:', name: 'enterName');
  String get yourName => Intl.message('Your name', name: 'yourName');
  String get submitScore => Intl.message('Submit Score', name: 'submitScore');
  String get playAgain => Intl.message('Play Again', name: 'playAgain');
  String get globalLeaderboard => Intl.message('Global Leaderboard', name: 'globalLeaderboard');
  String get noScoresYet => Intl.message('No scores yet', name: 'noScoresYet');
  String get close => Intl.message('Close', name: 'close');
  String get showLeaderboard => Intl.message('Show Leaderboard', name: 'showLeaderboard');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    Intl.defaultLocale = locale.languageCode;
    return AppLocalizations();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}