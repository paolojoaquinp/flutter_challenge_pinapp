// HU-01: Splash Screen UI. Observes [splashProvider] and navigates automatically
// once AsyncValue transitions to data. Navigation logic lives in the listener
// (not in initState) per the Riverpod best practices.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge_pinapp/src/features/splash/presentation/providers/splash_notifier.dart';
import 'package:flutter_challenge_pinapp/src/features/movies/presentation/page/home_page.dart';


// TODO: review migrate to kiss focus stateless widget
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for state transitions — navigate once init is complete.
    ref.listen<AsyncValue<void>>(splashProvider, (_, next) {
      next.whenOrNull(
        data: (_) => Navigator.of(context).pushReplacementNamed(HomePage.routeName),
        error: (_, __) {
          // Error state is rendered inline — let the user retry.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to initialise. Retrying…')),
          );
          ref.read(splashProvider.notifier).retry();
        },
      );
    });

    final state = ref.watch(splashProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: state.when(
          data: (_) => _SplashContent(isLoaded: true),
          loading: () => _SplashContent(isLoaded: false),
          error: (_, __) => _SplashContent(isLoaded: false),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  final bool isLoaded;
  const _SplashContent({required this.isLoaded});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // App logo / icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE50914), Color(0xFFB00610)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66E50914),
                blurRadius: 32,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.movie_filter_rounded, size: 64, color: Colors.white),
        ),
        const SizedBox(height: 32),
        const Text(
          'PinApp Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Discover your next favourite',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 48),
        if (!isLoaded)
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: const Color(0xFFE50914),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
      ],
    );
  }
}
