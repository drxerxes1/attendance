// ignore_for_file: avoid_print

import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/model/member_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Collections
  CollectionReference get membersRef => _db.collection('members');
  CollectionReference get attendanceRef => _db.collection('attendance');

  // ----------------- MEMBER METHODS -----------------

  Future<void> addMember(Member member) async {
    try {
      await membersRef.add(member.toMap());
    } catch (e) {
      print('Error adding member: $e');
      rethrow;
    }
  }

  Future<Member> getMember(String id) async {
    try {
      final doc = await membersRef.doc(id).get();
      return Member.fromDocument(doc);
    } catch (e) {
      print('Error fetching member: $e');
      rethrow;
    }
  }

  Future<void> updateMember(Member member) async {
    try {
      await membersRef.doc(member.id).update(member.toUpdateMap());
    } catch (e) {
      print('Error updating member: $e');
      rethrow;
    }
  }

  Future<void> deleteMember(String id) async {
    try {
      await membersRef.doc(id).delete();
    } catch (e) {
      print('Error deleting member: $e');
      rethrow;
    }
  }

  Stream<List<Member>> getAllMembers() {
    return membersRef.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Member.fromDocument(doc)).toList());
  }

  // ----------------- ATTENDANCE METHODS -----------------

  Future<void> addAttendance({
    required String serviceName,
    required DateTime date,
    required Attendees preacher,
    required String sermonTitle,
    required String sermonScripture,
    required Attendees worshipLeader,
    required Attendees songLeader,
    required List<String> songs,
    required List<Attendees> attendees,
    required List<Map<String, dynamic>> visitors,
  }) async {
    final docRef = attendanceRef.doc();

    final attendanceData = {
      'id': docRef.id,
      'service_name': serviceName,
      'date': date.toIso8601String(),
      'sermon': {
        'preacher': preacher.toMap(),
        'title': sermonTitle,
        'scripture': sermonScripture,
      },
      'worship_leader': worshipLeader.toMap(),
      'song_leader': songLeader.toMap(),
      'songs': songs,
      'attendance': attendees.map((member) => member.toMap()).toList(),
      'visitors': visitors,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(attendanceData);
  }

  Future<DocumentSnapshot> getAttendance(String id) async {
    return await attendanceRef.doc(id).get();
  }

  Future<void> updateAttendance(String id, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await attendanceRef.doc(id).update(data);
  }

  Future<void> deleteAttendance(String id) async {
    await attendanceRef.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> getAllAttendance() {
    return attendanceRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }
}
