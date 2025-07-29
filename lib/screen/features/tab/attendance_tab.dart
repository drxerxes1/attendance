import 'package:attendance/helper/global.dart';
import 'package:attendance/model/member.dart';
import 'package:attendance/screen/controllers/service_controller.dart';
import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final firestoreService = FirestoreService();
    final controller = Get.find<ServiceController>();

    return StreamBuilder<List<Member>>(
      stream: firestoreService.getAllMembers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final members = snapshot.data ?? [];

        return Obx(() => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.width * 0.05),
                  const Text('Attendance',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: mq.width * 0.05),
                  ...members.map((member) {
                    final isChecked =
                        controller.checkedMemberIds.contains(member.id);
                    return GestureDetector(
                      onTap: () => controller.toggleMember(member.id),
                      child: Container(
                        height: mq.width * 0.1,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade800),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                member.name,
                                style: TextStyle(
                                  fontSize: mq.width * 0.035,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: isChecked,
                              activeColor: primaryColor,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                controller.setMember(member.id, value ?? false);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ));
      },
    );
  }
}
