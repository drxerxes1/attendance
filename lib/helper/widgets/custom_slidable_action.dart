import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomSlidableActionWidget extends StatelessWidget {
  final void Function(BuildContext) onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;

  const CustomSlidableActionWidget({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderRadius: BorderRadius.circular(8),
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
