import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modulo/features/game/game_screen.dart';
// Login screen intentionally not used for launch; auto guest auth.
import 'package:modulo/l10n/app_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:modulo/core/services/analytics_service.dart';
import 'package:modulo/core/services/ad_service.dart';
import 'package:modulo/core/services/consent_service.dart';
import 'package:modulo/core/services/purchase_service.dart';
import 'package:modulo/core/config/firebase_options.dart';
import 'package:modulo/core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Setup dependency injection
  setupServiceLocator();

  // Configure consent and ad request settings before initializing ads
  await getIt<ConsentService>().configure();
  await getIt<AdService>().initialize();
  await getIt<PurchaseService>().initialize();
  getIt<AdService>().loadInterstitial();
  runApp(const ModuloApp());
}

class ModuloApp extends StatelessWidget {
  const ModuloApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
    return MaterialApp(
      title: 'Modulo Squares',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [observer],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        // Add other supported locales here
      ],
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Log app open on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<AnalyticsService>().logAppOpen();
    });

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) {
          // Auto sign-in anonymously and show a loading indicator until ready.
          FirebaseAuth.instance.signInAnonymously();
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // Set analytics user id once we have a user
        getIt<AnalyticsService>().setUserIdFromAuth(user);
        return const GameScreen();
      },
    );
  }
}
