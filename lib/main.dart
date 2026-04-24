// Entry point — wires all app-level dependencies: Hive, Firebase, dotenv, Riverpod.
// SRP: main() is solely responsible for app bootstrapping; it delegates all
//      business logic to the appropriate services and providers.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/home_page.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/movie_detail_page.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/search_page.dart';
import 'package:flutter_challenge_pinapp/src/features/shared/data/models/movie_model.dart';
import 'package:flutter_challenge_pinapp/src/features/splash/presentation/page/splash_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load environment variables — must complete before any constant access.
  await dotenv.load(fileName: '.env');

  // 2. Initialise Hive with the Flutter path provider.
  await Hive.initFlutter();
  // Register the hand-written TypeAdapter for MovieModel (ADR-004, no code-gen).
  if (!Hive.isAdapterRegistered(MovieModelAdapter().typeId)) {
    Hive.registerAdapter(MovieModelAdapter());
  }

  // 3. Initialise Firebase (assumes firebase_options.dart is present).
  // If firebase_options.dart is not yet generated, comment out this block and
  // initialise manually or via FlutterFire CLI.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase init failures must not crash the app — Remote Config will
    // surface defaults or timeout gracefully.
    debugPrint('[main] Firebase init failed: $e');
  }

  runApp(
    // ProviderScope is required by all Riverpod providers.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinApp Movies',
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),
      initialRoute: SplashPage.routeName,
      routes: {
        SplashPage.routeName: (_) => const SplashPage(),
        HomePage.routeName: (_) => const HomePage(),
        SearchPage.routeName: (_) => const SearchPage(),
        MovieDetailPage.routeName: (context) {
          // Route arguments: movie id passed as int.
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return MovieDetailPage(movieId: id);
        },
      },
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE50914),
        secondary: Color(0xFFFFC107),
        surface: Color(0xFF1A1A1A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D0D),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: Color(0xFFE50914),
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF888888),
      ),
      useMaterial3: true,
    );
  }
}
