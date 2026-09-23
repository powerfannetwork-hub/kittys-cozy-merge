import 'package:flutter/material.dart';

class WinScreen extends StatelessWidget {
  final int level;
  final int score;

  const WinScreen({
    super.key,
    required this.level,
    required this.score,
  });

  int get stars {
    if (score >= 1500) return 3;
    if (score >= 1000) return 2;
    if (score >= 500) return 1;
    return 0;
  }

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
                "🎉 LEVEL COMPLETE!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  stars,
                  (index) => const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                ),
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
                  child:
                      const Text("NEXT LEVEL"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
