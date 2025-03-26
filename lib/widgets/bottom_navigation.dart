import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  /// The index of the currently selected item.
  final int currentIndex;

  /// Called when a navigation item is tapped, providing the [index].
  final ValueChanged<int> onTap;

  /// Creates a custom bottom nav with 5 'slots':
  /// [0] Home, [1] Transaction, [2] + Button, [3] Budget, [4] Profile
  const CustomBottomNavigation({
    Key? key,
    this.currentIndex = 0,
    required this.onTap,
  }) : super(key: key);

  // Purple color from your screenshot: #7F3DFF
  static const Color _purpleColor = Color(0xFF7F3DFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // total height of the bottom nav
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left group: Home (index 0), Transaction (index 1)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(icon: Icons.home_filled, label: 'Home', index: 0),
                _buildNavItem(
                  icon: Icons.compare_arrows_rounded,
                  label: 'Transaction',
                  index: 1,
                ),
              ],
            ),
          ),

          // Center big button (Plus) at index 2
          _buildCenterButton(),

          // Right group: Budget (index 3), Profile (index 4)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.pie_chart_rounded,
                  label: 'Budget',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_2_rounded,
                  label: 'Profile',
                  index: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a navigation item with an icon and label.
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = (currentIndex == index);

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? _purpleColor : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? _purpleColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the large circular button in the center with a plus icon.
  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: _purpleColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
