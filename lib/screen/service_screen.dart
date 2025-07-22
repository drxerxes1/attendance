import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/screen/features/add/add_attendance.dart';
import 'package:attendance/screen/features/add/add_information.dart';
import 'package:attendance/screen/features/add/add_visitors.dart';
import 'package:flutter/material.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Add Service'),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07, vertical: mq.width * 0.05),
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
                    AddInformation(),
                    AddAttendance(),
                    AddVisitors(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
