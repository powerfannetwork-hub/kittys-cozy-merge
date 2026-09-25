import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../services/game_storage_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  GameStorageService get _storage =>
      GameStorageService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FB),
      body: SafeArea(
        child: Stack(
          children: [
            const _BackgroundDecoration(),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                18,
                14,
                18,
                110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 22),
                  _buildHeroCard(context),
                  const SizedBox(height: 20),
                  _buildResourceRow(),
                  const SizedBox(height: 22),
                  _buildPlayCard(context),
                  const SizedBox(height: 20),
                  _buildDailyRewardCard(context),
                  const SizedBox(height: 20),
                  _buildFeatureSection(),
                ],
              ),
            ),

            const _BottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 16,
                offset: Offset(0, 7),
                color: Color(0x14000000),
              ),
            ],
          ),
          child: const Icon(
            Icons.pets_rounded,
            size: 27,
            color: Color(0xFFFF69AD),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Kitty's",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9A8390),
                ),
              ),
              Text(
                'Cozy Merge',
                style: TextStyle(
                  fontSize: 20,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF342632),
                ),
              ),
            ],
          ),
        ),
        _roundActionButton(
          icon: Icons.settings_rounded,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFC9E2),
            Color(0xFFFF9CC8),
            Color(0xFFEFA4FF),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 12),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'WELCOME HOME',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB2477F),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Let’s make\nsomething cozy!',
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF342632),
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Match gems, discover boosters\nand help Kitty build her cozy world.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF65495B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _CatCharacter(),
        ],
      ),
    );
  }

  Widget _buildResourceRow() {
    return Row(
      children: [
        Expanded(
          child: _ResourceCard(
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFFFF5E88),
            label: 'Lives',
            value: '${_storage.lives}/${AppConstants.maximumLives}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ResourceCard(
            icon: Icons.diamond_rounded,
            iconColor: const Color(0xFF8D72FF),
            label: 'Diamonds',
            value: '${_storage.diamonds}',
          ),
        ),
      ],
    );
  }

  Widget _buildPlayCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 8),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: const Color(0xFFFFEEF6),
                ),
                child: const Icon(
                  Icons.map_rounded,
                  color: Color(0xFFFF68AA),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adventure Map',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF342632),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Continue your cozy journey',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9A8390),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFBCAAB5),
                size: 27,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Level Map is coming in the next build.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFF68AA),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_arrow_rounded,
                    size: 27,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'PLAY',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRewardCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF0B8),
            Color(0xFFFFD86B),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x18000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: Color(0xFFD18B19),
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Cozy Gift',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF5D451D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'A little surprise is waiting for you.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF80662E),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Daily rewards will be activated soon.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF9D6A13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'OPEN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Cozy World',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF342632),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _FeatureCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Boosters',
                subtitle: 'Power up',
                color: const Color(0xFF8D72FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FeatureCard(
                icon: Icons.storefront_rounded,
                title: 'Shop',
                subtitle: 'Cozy items',
                color: const Color(0xFFFF7AAB),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _FeatureCard(
                icon: Icons.emoji_events_rounded,
                title: 'Trophy',
                subtitle: 'Your wins',
                color: const Color(0xFFF1B43B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _roundActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: const Color(0xFF705C69),
            size: 23,
          ),
        ),
      ),
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 210,
              height: 210,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x18FF7EB5),
              ),
            ),
          ),
          Positioned(
            top: 300,
            left: -100,
            child: Container(
              width: 190,
              height: 190,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x128D72FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatCharacter extends StatelessWidget {
  const _CatCharacter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 145,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(55),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 17,
            child: Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFF5F9),
              ),
              child: const Icon(
                Icons.pets_rounded,
                size: 53,
                color: Color(0xFFE99AB9),
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            child: Icon(
              Icons.favorite_rounded,
              size: 30,
              color: Color(0xFFFF70A9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            blurRadius: 17,
            offset: Offset(0, 7),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A8390),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF342632),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 7),
            color: Color(0x0E000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Color(0xFF342632),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA18D99),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 14,
      right: 14,
      bottom: 12,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              blurRadius: 24,
              offset: Offset(0, 9),
              color: Color(0x18000000),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: true,
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.map_rounded,
              label: 'Map',
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.shopping_bag_rounded,
              label: 'Shop',
              onTap: () {},
            ),
            _NavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected
                  ? const Color(0xFFFF68AA)
                  : const Color(0xFFB7A8B1),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: selected
                    ? FontWeight.w900
                    : FontWeight.w600,
                color: selected
                    ? const Color(0xFFFF68AA)
                    : const Color(0xFF9F8E98),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
