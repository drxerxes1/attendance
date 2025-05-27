import 'package:attendance/helper/global.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String label;
  final bool isEnabled;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(fontSize: size.width * 0.035),
          ),
        ),
        SizedBox(height: size.width * 0.02),
        SizedBox(
          height: 40,
          child: TextField(
            enabled: isEnabled,
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
                fontSize: size.width * 0.035,
                color: isEnabled ? Colors.white : Colors.white54),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                  color: Colors.white30, fontSize: size.width * 0.035),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: primaryColor, width: 1.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}
