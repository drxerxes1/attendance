// ignore_for_file: deprecated_member_use

import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/widgets/custom_alert_dialog.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_datepicker.dart';
import 'package:attendance/helper/widgets/custom_slidable_action.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen({super.key});

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  // show member modal
  void showMemberModal({Map<String, dynamic>? member, String? docId}) {
    final isEdit = member != null;

    if (isEdit) {
      nameController.text = member['name'] ?? '';
      final birthdayRaw = member['birthday'];
      if (birthdayRaw != null) {
        try {
          final date = (birthdayRaw is Timestamp)
              ? birthdayRaw.toDate()
              : DateTime.parse(birthdayRaw.toString());
          birthdayController.text = DateFormat('MM-dd-yyyy').format(date);
        } catch (_) {
          birthdayController.clear();
        }
      }
    } else {
      nameController.clear();
      birthdayController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Member' : 'Add Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
                label: 'Name',
                controller: nameController,
                hintText: 'Enter name'),
            SizedBox(height: mq.width * 0.02),
            CustomDatePickerTextField(
              controller: birthdayController,
              label: 'Birthday',
              hintText: 'MM-DD-YYYY',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final birthday =
                  DateFormat('MM-dd-yyyy').parse(birthdayController.text);

              if (isEdit && docId != null) {
                firestoreService.updateMember(
                    docId, nameController.text, birthday);
              } else {
                firestoreService.addMember(nameController.text, birthday);
              }

              nameController.clear();
              birthdayController.clear();
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Manage Members'),
      floatingActionButton: FloatingActionButton(
        onPressed: showMemberModal,
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getAllMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No members found.'));
          }

          final members = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final name = member['name'] ?? '';
                final birthdayRaw = member['birthday'];

                // Format birthday
                String birthday = '';
                if (birthdayRaw != null) {
                  try {
                    final date = (birthdayRaw is Timestamp)
                        ? birthdayRaw.toDate()
                        : DateTime.parse(birthdayRaw.toString());
                    birthday = DateFormat('MM-dd-yyyy').format(date);
                  } catch (_) {
                    birthday = 'Invalid date';
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Slidable(
                    key: ValueKey(member['id']),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        CustomSlidableActionWidget(
                          onPressed: (_) {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => CustomAlertDialog(
                                title: "Delete Member",
                                message:
                                    "Are you sure you want to delete this member?",
                                type: AlertType.error,
                                onConfirm: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    firestoreService.deleteMember(member['id']);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Member deleted.",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                },
                              ),
                            );
                          },
                          backgroundColor: Colors.red.withOpacity(0.15),
                          foregroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        CustomSlidableActionWidget(
                          onPressed: (context) {
                            showMemberModal(
                                member: member, docId: member['id']);
                          },
                          backgroundColor: Colors.blue.withOpacity(0.15),
                          foregroundColor: Colors.blue,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Birthday: $birthday',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
