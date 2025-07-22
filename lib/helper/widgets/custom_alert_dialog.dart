// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

enum AlertType { success, warning, error }

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final VoidCallback? onConfirm;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.onConfirm,
  });

  Color getColor() {
    switch (type) {
      case AlertType.success:
        return Colors.green;
      case AlertType.warning:
        return Colors.amber;
      case AlertType.error:
        return Colors.red;
    }
  }

  IconData getIcon() {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.error:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: getColor().withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(getIcon(), color: getColor()),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: getColor())),
        ],
      ),
      content: Text(message, style: const TextStyle(fontSize: 16,)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close", style: TextStyle(color: Colors.white)),
        ),
        if (onConfirm != null)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: getColor()),
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}
