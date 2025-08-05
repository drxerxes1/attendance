import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  // Tab controller
  RxBool isAttendanceTabLoaded = false.obs;
  RxBool isVisitorTabLoaded = false.obs;

  // Information Tab
  final serviceNameController = TextEditingController();
  final dateController = TextEditingController();
  final selectedPreacherId = RxString('NonMember');
  final selectedSongLeaderId = RxString('NonMember');
  final selectedWorshipLeaderId = RxString('NonMember');
  final preacherController = TextEditingController();
  final titleController = TextEditingController();
  final scriptureController = TextEditingController();
  final worshipLeaderController = TextEditingController();
  final songLeaderController = TextEditingController();

  final songs = <String>[].obs;

  void addSong(String song) {
    final trimmed = song.trim();
    final isDuplicate =
        songs.any((s) => s.toLowerCase() == trimmed.toLowerCase());
    if (trimmed.isNotEmpty && !isDuplicate) {
      songs.add(trimmed);
    }
  }

  bool isDuplicateSong(String song) {
    final trimmed = song.trim().toLowerCase();
    return songs.any((v) => v.toLowerCase() == trimmed);
  }

  void removeSong(int index) {
    if (index >= 0 && index < songs.length) {
      songs.removeAt(index);
    }
  }

  // Dispose controllers if needed
  @override
  void onClose() {
    preacherController.dispose();
    titleController.dispose();
    scriptureController.dispose();
    worshipLeaderController.dispose();
    songLeaderController.dispose();
    super.onClose();
  }

  // Attendance
  final checkedMembers = <String, String>{}.obs;

  void toggleMember(String id, String name) {
    if (checkedMembers.containsKey(id)) {
      checkedMembers.remove(id);
    } else {
      checkedMembers[id] = name;
    }
  }

  void setMember(String id, String name, bool checked) {
    if (checked) {
      checkedMembers[id] = name;
    } else {
      checkedMembers.remove(id);
    }
  }

  void setCheckedMembers(Map<String, String> members) {
    checkedMembers.clear();
    checkedMembers.addAll(members);
  }

  // Visitors
  final visitors = <String>[].obs;

  void addVisitor(String name) {
    final trimmed = name.trim();
    final isDuplicate =
        visitors.any((v) => v.toLowerCase() == trimmed.toLowerCase());
    if (trimmed.isNotEmpty && !isDuplicate) {
      visitors.add(trimmed);
    }
  }

  bool isDuplicateVisitor(String name) {
    final trimmed = name.trim().toLowerCase();
    return visitors.any((v) => v.toLowerCase() == trimmed);
  }

  void removeVisitor(int index) {
    if (index >= 0 && index < visitors.length) {
      visitors.removeAt(index);
    }
  }
}
