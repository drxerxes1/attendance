
class Attendance {
  final String id;
  final DateTime date;
  final Amount amount;
  final Sermon sermon;
  final Member worshipLeader;
  final Member songLeader;
  final List<String> songs;
  final List<Member> attendance;
  final List<Visitor> visitors;
  final List<Birthday> birthdays;

  Attendance({
    required this.id,
    required this.date,
    required this.amount,
    required this.sermon,
    required this.worshipLeader,
    required this.songLeader,
    required this.songs,
    required this.attendance,
    required this.visitors,
    required this.birthdays,
  });

  factory Attendance.fromMap(Map<String, dynamic> data) {
    return Attendance(
      id: data['id'] ?? '',
      date: DateTime.parse(data['date']),
      amount: Amount.fromMap(data['amount']),
      sermon: Sermon.fromMap(data['sermon']),
      worshipLeader: Member.fromMap(data['worship leader']),
      songLeader: Member.fromMap(data['song leader']),
      songs: List<String>.from(data['songs'] ?? []),
      attendance: List<Map<String, dynamic>>.from(data['attendance'] ?? [])
          .map((e) => Member.fromMap(e))
          .toList(),
      visitors: List<Map<String, dynamic>>.from(data['visitors'] ?? [])
          .map((e) => Visitor.fromMap(e))
          .toList(),
      birthdays: List<Map<String, dynamic>>.from(data['birthdays'] ?? [])
          .map((e) => Birthday.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount.toMap(),
      'sermon': sermon.toMap(),
      'worship leader': worshipLeader.toMap(),
      'song leader': songLeader.toMap(),
      'songs': songs,
      'attendance': attendance.map((e) => e.toMap()).toList(),
      'visitors': visitors.map((e) => e.toMap()).toList(),
      'birthdays': birthdays.map((e) => e.toMap()).toList(),
    };
  }
}

class Amount {
  final double tithe;
  final double offering;

  Amount({required this.tithe, required this.offering});

  factory Amount.fromMap(Map<String, dynamic> data) {
    return Amount(
      tithe: (data['tithe'] ?? 0).toDouble(),
      offering: (data['offering'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tithe': tithe,
      'offering': offering,
    };
  }
}

class Sermon {
  final Member preacher;
  final String title;
  final String scripture;

  Sermon({
    required this.preacher,
    required this.title,
    required this.scripture,
  });

  factory Sermon.fromMap(Map<String, dynamic> data) {
    return Sermon(
      preacher: Member.fromMap(data['preacher']),
      title: data['title'] ?? '',
      scripture: data['scripture'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'preacher': preacher.toMap(),
      'title': title,
      'scripture': scripture,
    };
  }
}

class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});

  factory Member.fromMap(Map<String, dynamic> data) {
    return Member(
      id: data['id'] ?? '',
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
  final DateTime birthday;

  Visitor({required this.name, required this.birthday});

  factory Visitor.fromMap(Map<String, dynamic> data) {
    return Visitor(
      name: data['name'] ?? '',
      birthday: DateTime.parse(data['birthday']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthday': birthday.toIso8601String(),
    };
  }
}

class Birthday {
  final String id;
  final String name;
  final DateTime birthday;

  Birthday({
    required this.id,
    required this.name,
    required this.birthday,
  });

  factory Birthday.fromMap(Map<String, dynamic> data) {
    return Birthday(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      birthday: DateTime.parse(data['birthday']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthday': birthday.toIso8601String(),
    };
  }
}
