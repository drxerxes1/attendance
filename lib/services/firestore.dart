import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Collections
  CollectionReference get membersRef => _db.collection('members');
  CollectionReference get attendanceRef => _db.collection('attendance');

  // ----------------- MEMBER METHODS -----------------

  Future<void> addMember(String name, DateTime birthday) async {
    final formattedDate = birthday.toIso8601String().split('T').first;
    await membersRef.add({
      'name': name,
      'birthday': formattedDate,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getMember(String id) async {
    return await membersRef.doc(id).get();
  }

  Future<void> updateMember(String id, String name, DateTime birthday) async {
    final formattedDate = birthday.toIso8601String().split('T').first;
    await membersRef.doc(id).update({
      'name': name,
      'birthday': formattedDate,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteMember(String id) async {
    await membersRef.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> getAllMembers() {
    return membersRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
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
