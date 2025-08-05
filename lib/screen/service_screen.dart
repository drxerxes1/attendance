import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/validation/attendance_validator.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_datepicker.dart';
import 'package:attendance/helper/widgets/custom_dialog.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/model/attendance_model.dart';
import 'package:attendance/screen/controllers/service_controller.dart';
import 'package:attendance/screen/home_screen.dart';
import 'package:attendance/screen/tabs/attendance_tab.dart';
import 'package:attendance/screen/tabs/information_tab.dart';
import 'package:attendance/screen/tabs/visitors_tab.dart';
import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServiceScreen extends StatefulWidget {
  final Map<String, dynamic>? attendanceData;
  const ServiceScreen({super.key, this.attendanceData});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {
  final FirestoreService firestoreService = FirestoreService();

  late TabController _tabController;
  late ServiceController controller;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        controller.isAttendanceTabLoaded.value = true;
      } else if (_tabController.index == 2) {
        controller.isVisitorTabLoaded.value = true;
      }
    });

    Get.put(ServiceController());
    controller = Get.find<ServiceController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateAttendanceData();
    });
  }

  void _populateAttendanceData() {
    final data = widget.attendanceData;
    if (data != null) {
      controller.serviceNameController.text = data['service_name'] ?? '';
      controller.dateController.text = DateFormat('MM-dd-yyyy')
          .format(DateTime.tryParse(data['date']) ?? DateTime.now());
      controller.preacherController.text =
          data['sermon']['preacher']['name'] ?? '';
      controller.titleController.text = data['sermon']['title'] ?? '';
      controller.scriptureController.text = data['sermon']['scripture'] ?? '';
      controller.worshipLeaderController.text =
          data['worship_leader']['name'] ?? '';
      controller.songLeaderController.text = data['song_leader']['name'] ?? '';

      // IDs (optional - handle if you store them in Firestore)
      controller.selectedPreacherId.value = data['preacher_id'] ?? 'NonMember';
      controller.selectedWorshipLeaderId.value =
          data['worship_leader_id'] ?? 'NonMember';
      controller.selectedSongLeaderId.value =
          data['song_leader_id'] ?? 'NonMember';

      // Songs
      final songList = data['songs'];
      if (songList is List) {
        controller.songs.value = List<String>.from(songList);
      }

      // Attendees
      final attendees = data['attendance'];
      if (attendees is List) {
        final Map<String, String> bulkChecked = {};
        for (var att in attendees) {
          if (att is Map<String, dynamic> &&
              att.containsKey('id') &&
              att.containsKey('name')) {
            final id = att['id']?.toString();
            final name = att['name']?.toString();
            if (id != null && name != null) {
              bulkChecked[id] = name;
            }
          }
        }
        controller.setCheckedMembers(bulkChecked);
      }

      // Visitors
      final visitors = data['visitors'];
      if (visitors is List) {
        controller.visitors.value =
            visitors.map((v) => v['name'].toString()).toList();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
            title:
                widget.attendanceData == null ? 'Add Service' : 'Edit Service'),
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
                      controller: controller.serviceNameController,
                      hintText: 'Service',
                      label: 'Service',
                    ),
                    SizedBox(height: mq.width * 0.03),
                    CustomDatePickerTextField(
                      controller: controller.dateController,
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
                  physics: const NeverScrollableScrollPhysics(), // optional
                  children: [
                    const InformationTab(),
                    Obx(() => controller.isAttendanceTabLoaded.value
                        ? const AttendanceTab()
                        : Container()),
                    Obx(() => controller.isVisitorTabLoaded.value
                        ? const VisitorTab()
                        : Container()),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
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

            // Validations

            final validations = [
              AttendanceValidator.validateTextfield(
                  controller.serviceNameController.text.trim(), "Service Name"),
              AttendanceValidator.validateTextfield(
                  controller.preacherController.text.trim(), "Preacher"),
              AttendanceValidator.validateTextfield(
                  controller.titleController.text.trim(), "Sermon Title"),
              AttendanceValidator.validateTextfield(
                  controller.scriptureController.text.trim(),
                  "Sermon Scripture"),
              AttendanceValidator.validateTextfield(
                  controller.worshipLeaderController.text.trim(),
                  "Worship Leader"),
              AttendanceValidator.validateTextfield(
                  controller.songLeaderController.text.trim(), "Song Leader"),
            ];

            for (final result in validations) {
              if (!result.isValid) {
                CustomDialog.error(result.error!);
                return;
              }
            }

            if (controller.songs.isEmpty) {
              CustomDialog.error("At least one song must be added.");
              return;
            }

            final attendeeValidation =
                AttendanceValidator.validateAttendees(attendees);
            if (!attendeeValidation.isValid) {
              CustomDialog.error(attendeeValidation.error!);
              return;
            }

            final dateText = controller.dateController.text.trim();
            final dateValidation = AttendanceValidator.validateDate(dateText);
            if (!dateValidation.isValid) {
              CustomDialog.error(dateValidation.error!);
              return;
            }

            final date = DateFormat('MM-dd-yyyy').parseStrict(dateText);

            if (widget.attendanceData == null) {
              // ADD
              await firestoreService.addAttendance(
                serviceName: controller.serviceNameController.text.trim(),
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
              Get.offAll(() => const HomeScreen());
            } else {
              // EDIT
              final docId = widget
                  .attendanceData!['id']; // assuming you added it during fetch
              await firestoreService.updateAttendance(
                docId: docId,
                serviceName: controller.serviceNameController.text.trim(),
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

              CustomDialog.success('Service updated successfully!');
              Get.offAll(() => const HomeScreen());
            }
          },
          shape: const CircleBorder(),
          backgroundColor: primaryColor,
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
