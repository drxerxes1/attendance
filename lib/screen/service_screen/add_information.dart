import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController serviceController = TextEditingController();

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
                padding: EdgeInsets.all(mq.width * 0.07),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: serviceController,
                      hintText: 'Service',
                      label: 'Service',
                    ),
                    SizedBox(height: mq.width * 0.03),
                    CustomTextField(
                      controller: serviceController,
                      hintText: 'Date',
                      label: 'Date',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab bar with rounded indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
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

              // Tab content (optional for now)
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    Center(child: Text("Information Content")),
                    Center(child: Text("Attendance Content")),
                    Center(child: Text("Visitors Content")),
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
