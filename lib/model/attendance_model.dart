import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String id;
  final DateTime date;
  final Sermon sermon;
  final Attendees worshipLeader;
  final Attendees songLeader;
  final List<String> songs;
  final List<Attendees> attendance;
  final List<Visitor> visitors;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Attendance({
    required this.id,
    required this.date,
    required this.sermon,
    required this.worshipLeader,
    required this.songLeader,
    required this.songs,
    required this.attendance,
    required this.visitors,
    this.createdAt,
    this.updatedAt,
  });

  factory Attendance.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      throw const FormatException('Invalid date format');
    }

    return Attendance(
      id: doc.id,
      date: parseDate(data['date']),
      sermon: Sermon.fromMap(data['sermon']),
      worshipLeader: Attendees.fromMap(data['worship leader']),
      songLeader: Attendees.fromMap(data['song leader']),
      songs: List<String>.from(data['songs'] ?? []),
      attendance: List<Map<String, dynamic>>.from(data['attendance'] ?? [])
          .map((e) => Attendees.fromMap(e))
          .toList(),
      visitors: List<Map<String, dynamic>>.from(data['visitors'] ?? [])
          .map((e) => Visitor.fromMap(e))
          .toList(),
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap({bool includeTimestamps = true}) {
    final map = {
      'date': date.toIso8601String(),
      'sermon': sermon.toMap(),
      'worship leader': worshipLeader.toMap(),
      'song leader': songLeader.toMap(),
      'songs': songs,
      'attendance': attendance.map((e) => e.toMap()).toList(),
      'visitors': visitors.map((e) => e.toMap()).toList(),
    };

    if (includeTimestamps) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }

    return map;
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'date': date.toIso8601String(),
      'sermon': sermon.toMap(),
      'worship leader': worshipLeader.toMap(),
      'song leader': songLeader.toMap(),
      'songs': songs,
      'attendance': attendance.map((e) => e.toMap()).toList(),
      'visitors': visitors.map((e) => e.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class Sermon {
  final String id;
  final Attendees preacher;
  final String title;
  final String scripture;

  Sermon({
    required this.id,
    required this.preacher,
    required this.title,
    required this.scripture,
  });

  factory Sermon.fromMap(Map<String, dynamic> data) {
    return Sermon(
      id: data['id'] ?? '',
      preacher: Attendees.fromMap(data['preacher']),
      title: data['title'] ?? '',
      scripture: data['scripture'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'preacher': preacher.toMap(),
      'title': title,
      'scripture': scripture,
    };
  }
}

class Attendees {
  final String id;
  final String name;

  Attendees({required this.id, required this.name});

  factory Attendees.fromMap(Map<String, dynamic> data) {
    return Attendees(
      id: data['id'] ?? data['member_id'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Visitor {
  final String name;

  Visitor({required this.name});

  factory Visitor.fromMap(Map<String, dynamic> data) {
    return Visitor(
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
