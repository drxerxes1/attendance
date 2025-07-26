// ignore_for_file: avoid_print

import 'package:attendance/model/member.dart';
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

  Future<void> addAttendance(Map<String, dynamic> attendanceData) async {
    final docRef = attendanceRef.doc(); // Automatically generates a unique ID
    attendanceData['id'] = docRef.id; // Store the generated ID
    await docRef.set(attendanceData);
  }

  Future<DocumentSnapshot> getAttendance(String id) async {
    return await attendanceRef.doc(id).get();
  }

  Future<void> updateAttendance(String id, Map<String, dynamic> data) async {
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
