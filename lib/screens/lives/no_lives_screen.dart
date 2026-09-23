import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/lives_service.dart';

class NoLivesScreen extends StatefulWidget {
  const NoLivesScreen({super.key});

  @override
  State<NoLivesScreen> createState() => _NoLivesScreenState();
}

class _NoLivesScreenState extends State<NoLivesScreen> {
  Timer? _timer;

  Duration _remaining = Duration.zero;
  int _lives = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLives();
    _startTimer();
  }

  Future<void> _loadLives() async {
    final lives = await LivesService.refreshLives();
    final remaining =
        await LivesService.getNextLifeRemainingTime();

    if (!mounted) return;

    setState(() {
      _lives = lives;
      _remaining = remaining;
      _loading = false;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final lives = await LivesService.refreshLives();
        final remaining =
            await LivesService.getNextLifeRemainingTime();

        if (!mounted) return;

        setState(() {
          _lives = lives;
          _remaining = remaining;
        });

        if (lives > 0) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours
        .toString()
        .padLeft(2, '0');

    final minutes = (duration.inMinutes % 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  Future<void> _watchAd() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Rewarded Ad zai zo nan. Za mu haɗa shi daga baya.',
        ),
      ),
    );
  }

  Future<void> _useGems() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Gems system zai zo nan.',
        ),
      ),
    );
  }

  Future<void> _unlimitedLives() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Google Play purchase na \$0.99 zai zo nan.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),
      appBar: AppBar(
        title: const Text('Lives'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 75,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'No Lives Left',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Ka jira har sai an samu ❤️ na gaba.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Next ❤️ in',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(_remaining),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Lives: $_lives/5',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _watchAd,
                  icon: const Icon(
                    Icons.play_circle_fill,
                  ),
                  label: const Text(
                    'WATCH AD  +1 ❤️',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton.icon(
                  onPressed: _useGems,
                  icon: const Icon(
                    Icons.diamond,
                  ),
                  label: const Text(
                    'USE GEMS  +1 ❤️',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _unlimitedLives,
                  icon: const Icon(
                    Icons.all_inclusive,
                  ),
                  label: const Text(
                    'UNLIMITED LIVES • 6 HOURS • \$0.99',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Text(
                '❤️ Lives suna dawowa 1 duk bayan awa 2.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
