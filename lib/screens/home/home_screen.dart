import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // TOP BAR
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Player",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: 0.35,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "Level 1",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // STATUS BAR

              Row(
                children: [

                  Expanded(
                    child: _statusCard(
                      icon: Icons.favorite,
                      color: AppTheme.life,
                      value: "5",
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

              const SizedBox(height: 25),

              // PLAY BUTTON

              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "PLAY LEVEL 1",
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // DAILY REWARD

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
                subtitle: "Limited time events",
                icon: Icons.celebration,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "Friends",
                subtitle: "Send and receive lives",
                icon: Icons.people,
              ),

              const SizedBox(height: 12),

              _menuCard(
                title: "League",
                subtitle: "Current Rank #14",
                icon: Icons.emoji_events,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusCard({
    required IconData icon,
    required Color color,
    required String value,
    required String title,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
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
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
