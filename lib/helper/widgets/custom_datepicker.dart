import 'package:flutter/material.dart';
import 'package:attendance/helper/global.dart';
import 'package:intl/intl.dart';

class CustomDatePickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isEnabled;

  const CustomDatePickerTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.isEnabled = true,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Color(0xFF222222),
              onSurface: Colors.white,
            ),
            dialogTheme:
                const DialogThemeData(backgroundColor: Color(0xFF1E1E1E)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('MM-dd-yyyy').format(picked);
      controller.text = formatted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: size.width * 0.035),
        ),
        SizedBox(height: size.width * 0.02),
        SizedBox(
          height: 35,
          child: GestureDetector(
            onTap: isEnabled ? () => _selectDate(context) : null,
            child: AbsorbPointer(
              child: TextField(
                controller: controller,
                enabled: isEnabled,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: isEnabled ? Colors.white : Colors.white54,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: Colors.white30, fontSize: size.width * 0.035),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: Colors.white30, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: Colors.white30, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        const BorderSide(color: primaryColor, width: 1.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  suffixIcon: const Icon(Icons.calendar_today,
                      color: Colors.white30, size: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
