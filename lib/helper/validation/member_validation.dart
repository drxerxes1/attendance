// lib/core/validation/member_validator.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MemberValidatorResult {
  final bool isValid;
  final String? error;

  MemberValidatorResult(this.isValid, [this.error]);
}

class MemberValidator {
  static MemberValidatorResult validateName(String name) {
    if (name.trim().isEmpty) {
      return MemberValidatorResult(false, 'Name is required');
    }
    return MemberValidatorResult(true);
  }

  static MemberValidatorResult validateBirthday(String birthdayText) {
    if (birthdayText.trim().isEmpty) {
      return MemberValidatorResult(false, 'Birthday is required');
    }

    try {
      final birthday = DateFormat('MM-dd-yyyy').parseStrict(birthdayText);
      if (birthday.isAfter(DateTime.now())) {
        return MemberValidatorResult(false, 'Birthday cannot be in the future');
      }
    } catch (_) {
      return MemberValidatorResult(false, 'Invalid birthday format. Use MM-DD-YYYY');
    }

    return MemberValidatorResult(true);
  }

  static Future<MemberValidatorResult> checkDuplicateName({
    required String name,
    String? currentId,
  }) async {
    final existing = await FirebaseFirestore.instance
        .collection('members')
        .where('name', isEqualTo: name)
        .get();

    final isDuplicate = currentId == null
        ? existing.docs.isNotEmpty
        : existing.docs.any((doc) => doc.id != currentId);

    if (isDuplicate) {
      return MemberValidatorResult(false, 'A member with this name already exists');
    }

    return MemberValidatorResult(true);
  }
}
