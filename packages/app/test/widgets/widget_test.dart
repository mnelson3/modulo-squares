import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modulo/l10n/app_localizations.dart';
import 'package:modulo/features/game/game_screen.dart';
import 'package:modulo/core/di/service_locator.dart';

void main() {
  setUpAll(() {
    // Setup service locator for tests
    setupServiceLocator();
  });

  testWidgets('GameScreen displays score and restart button', (WidgetTester tester) async {
    // Increase the test surface to avoid overflow with the square grid + controls
    final view = tester.view;
    view.physicalSize = const Size(1200, 2200);
    view.devicePixelRatio = 1.0;
    addTearDown(() {
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
        ],
        home: GameScreen(),
      ),
    );
    // Allow initial async state (e.g., SharedPreferences load) to settle
    await tester.pumpAndSettle();

    // Verify score label using localization key prefix
    expect(find.textContaining(AppLocalizations.of(tester.element(find.byType(Scaffold))).score.split(':').first), findsWidgets);

    // Verify Restart button by localized label
    final ctx = tester.element(find.byType(Scaffold));
    expect(find.text(AppLocalizations.of(ctx).restart), findsOneWidget);
  });
}
