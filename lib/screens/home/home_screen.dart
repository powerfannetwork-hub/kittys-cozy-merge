import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../levels/level_map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primary,
                      Color(0xFF8E6BFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Player",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10),
                                child:
                                    const LinearProgressIndicator(
                                  value: 0.35,
                                  minHeight: 10,
                                  backgroundColor:
                                      Colors.white24,
                                  valueColor:
                                      AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Level 1 • XP 35%",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _statusCard(
                            icon: Icons.favorite,
                            color: AppTheme.life,
                            value: "5/5",
                            title: "Lives",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _statusCard(
                            icon: Icons.diamond,
                            color: AppTheme.gem,
                            value: "50",
                            title: "Gems",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _statusCard(
                            icon: Icons.monetization_on,
                            color: AppTheme.coin,
                            value: "500",
                            title: "Coins",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LevelMapScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "▶ PLAY",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Weekend Rush Event - Earn Extra Gems!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _menuCard(
                title: "Daily Reward",
                subtitle: "Claim today's reward",
                icon: Icons.card_giftcard,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "Quests",
                subtitle: "Complete tasks and earn rewards",
                icon: Icons.task_alt,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "Events",
                subtitle: "Join limited-time competitions",
                icon: Icons.celebration,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "Friends",
                subtitle: "Send and receive lives ❤️",
                icon: Icons.people,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "League",
                subtitle: "Current Rank #14",
                icon: Icons.emoji_events,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "Shop",
                subtitle: "Special Gem Offers Available",
                icon: Icons.store,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _statusCard({
    required IconData icon,
    required Color color,
    required String value,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              AppTheme.primary.withOpacity(0.15),
          child: Icon(
            icon,
            color: AppTheme.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}
