// widgets/custom_sidebar.dart
import 'package:attendance/helper/global.dart';
import 'package:attendance/screen/manage_members_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 80, // 👈 set your desired height here
              color: Colors.grey[850],
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      'assets/images/ic_foreground.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    'Hive Attendance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const ManageMembersScreen());
              },
              leading: const Icon(Icons.people, color: Colors.white),
              title:
                  const Text('Manage Members', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
