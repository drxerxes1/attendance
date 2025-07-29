import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/validation/member_validation.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_datepicker.dart';
import 'package:attendance/helper/widgets/custom_dialog.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/screen/controllers/service_controller.dart';
import 'package:attendance/screen/features/tab/attendance_tab.dart';
import 'package:attendance/screen/features/tab/information_tab.dart';
import 'package:attendance/screen/features/tab/visitors_tab.dart';
import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {
  final FirestoreService firestoreService = FirestoreService();

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
                    CustomDatePickerTextField(
                      controller: dateController,
                      label: 'Date',
                      hintText: 'MM-DD-YYYY',
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final controller = Get.find<ServiceController>();

            // Convert string input into Attendees
            final preacher = Attendees(
                id: controller.selectedPreacherId.toString(),
                name: controller.preacherController.text.trim());
            final worshipLeader = Attendees(
                id: controller.selectedWorshipLeaderId.value,
                name: controller.worshipLeaderController.text.trim());
            final songLeader = Attendees(
                id: controller.selectedSongLeaderId.value,
                name: controller.songLeaderController.text.trim());

            // Convert attendance IDs into Attendees (You might want to fetch their names from Firestore in a real app)
            final List<Attendees> attendees = controller.checkedMembers.entries
                .map((e) => Attendees(id: e.key, name: e.value))
                .toList();

            // Convert visitor strings to Visitor objects
            final List<Map<String, dynamic>> visitors =
                controller.visitors.map((v) {
              return Visitor(name: v).toMap();
            }).toList();

            final dateText = dateController.text.trim();

            final birthdayValidation =
                MemberValidator.validateBirthday(dateText);
            if (!birthdayValidation.isValid) {
              CustomDialog.error(birthdayValidation.error!);
              return;
            }

            final date = DateFormat('MM-dd-yyyy').parseStrict(dateText);

            // Call the method that saves to Firestore
            await firestoreService.addAttendance(
              serviceName: serviceController.text.trim(),
              date: date,
              preacher: preacher,
              sermonTitle: controller.titleController.text.trim(),
              sermonScripture: controller.scriptureController.text.trim(),
              worshipLeader: worshipLeader,
              songLeader: songLeader,
              songs: controller.songs.toList(),
              attendees: attendees,
              visitors: visitors,
            );

            CustomDialog.success('Service added successfully!');
          },
          shape: const CircleBorder(),
          backgroundColor: primaryColor,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
