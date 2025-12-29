import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final double progress;

  const LoadingOverlay({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/images/ic_launcher.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight:
                      6, // Optional: make it slightly thicker for better visibility
                  borderRadius:
                      BorderRadius.circular(3), // Optional: rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
