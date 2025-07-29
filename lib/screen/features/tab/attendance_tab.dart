import 'package:attendance/helper/global.dart';
import 'package:attendance/model/member.dart';
import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab>
    with AutomaticKeepAliveClientMixin {
  final FirestoreService firestoreService = FirestoreService();
  final Set<String> checkedMemberIds = {};

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mq = MediaQuery.of(context).size;
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

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mq.width * 0.05),
              const Text('Attendance',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: mq.width * 0.05),

              // Dynamic member list
              ...members.map((member) {
                final isChecked = checkedMemberIds.contains(member.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isChecked) {
                        checkedMemberIds.remove(member.id);
                      } else {
                        checkedMemberIds.add(member.id);
                      }
                    });
                  },
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
                            setState(() {
                              if (value == true) {
                                checkedMemberIds.add(member.id);
                              } else {
                                checkedMemberIds.remove(member.id);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
