import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/screen/controllers/service_controller.dart';
import 'package:attendance/screen/features/tab/attendance_tab.dart';
import 'package:attendance/screen/features/tab/information_tab.dart';
import 'package:attendance/screen/features/tab/visitors_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(ServiceController());
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    serviceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Add Service'),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * 0.07, vertical: mq.width * 0.05),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: serviceController,
                      hintText: 'Service',
                      label: 'Service',
                    ),
                    SizedBox(height: mq.width * 0.03),
                    CustomTextField(
                      controller: dateController,
                      hintText: 'Date',
                      label: 'Date',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: mq.width * 0.1,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Information'),
                    Tab(text: 'Attendance'),
                    Tab(text: 'Visitors'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    InformationTab(),
                    AttendanceTab(),
                    VisitorTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     final controller = Get.find<ServiceController>();

        //     // Validate basic required fields
        //     if (controller.preacherController.text.isEmpty ||
        //         controller.titleController.text.isEmpty ||
        //         controller.scriptureController.text.isEmpty ||
        //         controller.worshipLeaderController.text.isEmpty ||
        //         controller.songLeaderController.text.isEmpty ||
        //         controller.checkedMemberIds.isEmpty) {
        //       Get.snackbar(
        //           'Error', 'Please fill all required fields and attendance',
        //           backgroundColor: Colors.red, colorText: Colors.white);
        //       return;
        //     }

        //     // Construct `Member` objects (in real use, fetch from DB or map locally)
        //     Member preacher = Member(
        //         id: 'preacher_id', name: controller.preacherController.text);
        //     Member worshipLeader = Member(
        //         id: 'worship_leader_id',
        //         name: controller.worshipLeaderController.text);
        //     Member songLeader = Member(
        //         id: 'song_leader_id',
        //         name: controller.songLeaderController.text);

        //     // Dummy attendees, ideally matched from DB using their IDs
        //     final attendees = controller.checkedMemberIds
        //         .map((id) => Member(id: id, name: id))
        //         .toList();

        //     // Construct FirestoreService instance and call addAttendance
        //     final firestoreService = FirestoreService();
        //     await firestoreService.addAttendance(
        //       date: DateTime.now(),
        //       amount: {
        //         'tithe': 0.0,
        //         'offering': 0.0
        //       }, // you can replace this with actual data later
        //       preacher: preacher.,
        //       sermonTitle: controller.titleController.text,
        //       sermonScripture: controller.scriptureController.text,
        //       worshipLeader: worshipLeader,
        //       songLeader: songLeader,
        //       songs: controller.songs,
        //       attendees: attendees,
        //       birthdays: [], // no birthdays as per your latest instruction
        //       visitors:
        //           controller.visitors.map((name) => {'name': name}).toList(),
        //     );

        //     Get.snackbar('Success', 'Attendance saved successfully!',
        //         backgroundColor: Colors.green, colorText: Colors.white);
        //   },
        //   shape: const CircleBorder(),
        //   backgroundColor: primaryColor,
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
