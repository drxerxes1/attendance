import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Collections
  CollectionReference get membersRef => _db.collection('members');
  CollectionReference get attendanceRef => _db.collection('attendance');

  // ----------------- MEMBER METHODS -----------------

  Future<void> addMember(String id, String name, DateTime birthday) async {
    await membersRef.doc(id).set({
      'id': id,
      'name': name,
      'birthday': birthday.toIso8601String(),
    });
  }

  Future<DocumentSnapshot> getMember(String id) async {
    return await membersRef.doc(id).get();
  }

  Future<void> updateMember(String id, Map<String, dynamic> data) async {
    await membersRef.doc(id).update(data);
  }

  Future<void> deleteMember(String id) async {
    await membersRef.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> getAllMembers() {
    return membersRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // ----------------- ATTENDANCE METHODS -----------------

  Future<void> addAttendance(Map<String, dynamic> attendanceData) async {
    final id = attendanceData['id'];
    await attendanceRef.doc(id).set(attendanceData);
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
    return attendanceRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }
}
