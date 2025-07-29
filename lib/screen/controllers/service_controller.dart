import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  // Attendance
  final checkedMemberIds = <String>{}.obs;

  void toggleMember(String id) {
    if (checkedMemberIds.contains(id)) {
      checkedMemberIds.remove(id);
    } else {
      checkedMemberIds.add(id);
    }
  }

  void setMember(String id, bool checked) {
    if (checked) {
      checkedMemberIds.add(id);
    } else {
      checkedMemberIds.remove(id);
    }
  }

  // Information Tab
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
