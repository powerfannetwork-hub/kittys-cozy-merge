import 'package:flutter/material.dart';

class LoseScreen extends StatelessWidget {
  final int level;
  final int score;

  const LoseScreen({
    super.key,
    required this.level,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Text(
                "💔 LEVEL FAILED",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.red,
                size: 90,
              ),

              const SizedBox(height: 20),

              Text(
                "Score: $score",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "TRY AGAIN",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
