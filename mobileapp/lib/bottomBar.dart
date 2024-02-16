import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final double iconSize;
  final Color? backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<Widget> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final double containerHeight;
  final Curve curve;

  const BottomBar({
    Key ? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.itemCornerRadius = 24,
    this.containerHeight = 48,
    this.animationDuration = const Duration(milliseconds: 200),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.easeInOut,
  }) : assert(items.length >= 2 && items.length <= 5), super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: containerHeight,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: List.generate(items.length, (index) {
            return GestureDetector(
                onTap: () {
                  onItemSelected(index);
                },
                child: items[index]
            );
          }),
        ),
      ),
    );
  }
  
  
}