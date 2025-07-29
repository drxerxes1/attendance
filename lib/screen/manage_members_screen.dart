// ignore_for_file: deprecated_member_use

import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/validation/member_validation.dart';
import 'package:attendance/helper/widgets/custom_alert_dialog.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_datepicker.dart';
import 'package:attendance/helper/widgets/custom_dialog.dart';
import 'package:attendance/helper/widgets/custom_slidable_action.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/model/member_model.dart';
import 'package:attendance/services/firestore.dart';
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
  void showMemberModal({Member? member}) {
    final isEdit = member != null;

    if (isEdit) {
      nameController.text = member.name;
      birthdayController.text =
          DateFormat('MM-dd-yyyy').format(member.birthday);
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
            onPressed: () async {
              final name = nameController.text.trim();
              final birthdayText = birthdayController.text.trim();

              final nameValidation = MemberValidator.validateName(name);
              if (!nameValidation.isValid) {
                showError(nameValidation.error!);
                return;
              }

              final birthdayValidation =
                  MemberValidator.validateDate(birthdayText);
              if (!birthdayValidation.isValid) {
                showError(birthdayValidation.error!);
                return;
              }

              final duplicateCheck = await MemberValidator.checkDuplicateName(
                name: name,
                currentId: isEdit ? member.id : null,
              );

              if (!mounted) return;

              if (!duplicateCheck.isValid) {
                showError(duplicateCheck.error!);
                return;
              }

              final birthday =
                  DateFormat('MM-dd-yyyy').parseStrict(birthdayText);

              if (isEdit) {
                firestoreService.updateMember(Member(
                  id: member.id,
                  name: name,
                  birthday: birthday,
                ));
              } else {
                firestoreService.addMember(Member(
                  id: '',
                  name: name,
                  birthday: birthday,
                ));
              }

              nameController.clear();
              birthdayController.clear();

              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void showError(String message) {
    CustomDialog.error(message);
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
      body: StreamBuilder<List<Member>>(
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

                final birthday =
                    DateFormat('MMMM d, y').format(member.birthday);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Slidable(
                    key: ValueKey(member.id),
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
                                    firestoreService.deleteMember(member.id);
                                    CustomDialog.success(
                                      'Member deleted successfully',
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
                            showMemberModal(member: member);
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
                          member.name,
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
