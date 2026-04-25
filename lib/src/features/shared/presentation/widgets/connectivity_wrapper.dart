import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_challenge_pinapp/src/features/shared/presentation/providers/connectivity_provider.dart';

class ConnectivityWrapper extends ConsumerWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  void _showConnectivitySnackBar(BuildContext context, {required bool isOffline}) {
    // Hide current snackbars to avoid overlapping
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isOffline ? Icons.wifi_off : Icons.wifi,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              isOffline ? 'Sin conexión a internet' : 'Conexión restaurada',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        backgroundColor: isOffline ? Colors.redAccent : Colors.green,
        duration: isOffline ? const Duration(days: 1) : const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to connectivity changes globally
    ref.listen<AsyncValue<bool>>(
      connectivityProvider,
      (previous, next) {
        // Skip initial state or loading states if we want to be less annoying,
        // but normally we check if there's data.
        if (next is AsyncData<bool>) {
          final isConnected = next.value;
          final wasConnected = previous?.value ?? true; // assume connected initially

          if (isConnected != wasConnected) {
            _showConnectivitySnackBar(context, isOffline: !isConnected);
          }
        }
      },
    );

    return child;
  }
}
