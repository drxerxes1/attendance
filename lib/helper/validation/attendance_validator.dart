// lib/core/validation/member_validator.dart
import 'package:intl/intl.dart';

class AttendanceValidatorResult {
  final bool isValid;
  final String? error;

  AttendanceValidatorResult(this.isValid, [this.error]);
}

class AttendanceValidator {
  static AttendanceValidatorResult validateTextfield(
      String text, String fieldName) {
    if (text.trim().isEmpty) {
      return AttendanceValidatorResult(false, '$fieldName is required.');
    }
    return AttendanceValidatorResult(true);
  }

  static AttendanceValidatorResult validateAttendees(List attendees) {
    if (attendees.isEmpty) {
      return AttendanceValidatorResult(
          false, 'Please select at least one attendee.');
    }
    return AttendanceValidatorResult(true);
  }

  static AttendanceValidatorResult validateDate(String dateText) {
    if (dateText.trim().isEmpty) {
      return AttendanceValidatorResult(false, 'Date is required');
    }

    try {
      final birthday = DateFormat('MM-dd-yyyy').parseStrict(dateText);
      if (birthday.isAfter(DateTime.now())) {
        return AttendanceValidatorResult(false, 'Date cannot be in the future');
      }
    } catch (_) {
      return AttendanceValidatorResult(
          false, 'Invalid date format. Use MM-DD-YYYY');
    }

    return AttendanceValidatorResult(true);
  }
}
