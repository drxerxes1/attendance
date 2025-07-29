import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String id;
  final String name;
  final DateTime birthday;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Member({
    required this.id,
    required this.name,
    required this.birthday,
    this.createdAt,
    this.updatedAt,
  });

  // Convert Firestore document to Member object
  factory Member.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      throw const FormatException('Invalid date format');
    }

    return Member(
      id: doc.id,
      name: data['name'] ?? '',
      birthday: parseDate(data['birthday']),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Member object to Firestore-compatible map (for create/update)
  Map<String, dynamic> toMap({bool includeTimestamps = true}) {
    final map = {
      'name': name,
      'birthday': birthday.toIso8601String().split('T').first,
    };

    if (includeTimestamps) {
      map['createdAt'] = FieldValue.serverTimestamp().toString();
    }

    return map;
  }

  // To map for update
  Map<String, dynamic> toUpdateMap() {
    return {
      'name': name,
      'birthday': birthday.toIso8601String().split('T').first,
      'updatedAt': Timestamp.now(),
    };
  }
}
