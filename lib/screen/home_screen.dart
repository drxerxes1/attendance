import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/pref.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_sidebar.dart';
import 'package:attendance/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'service_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allAttendances = [];
  List<Map<String, dynamic>> filteredAttendances = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;

    _searchController.addListener(_filterSearchResults);
  }

  void _filterSearchResults() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredAttendances = allAttendances
          .where((item) =>
              item['attendance_name']
                      ?.toString()
                      .toLowerCase()
                      .contains(query) ==
                  true ||
              item['date']?.toString().toLowerCase().contains(query) == true)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: const CustomAppBar(title: appName),
      drawer: const CustomSidebar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(mq.width * 0.07),
          child: Column(
            children: [
              // Search Bar
              SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Date, Services...',
                    hintStyle: const TextStyle(color: Colors.white24),
                    suffixIcon: const Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: primaryColor),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Firestore Attendance List
              Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: firestoreService.getAllAttendance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final attendances = snapshot.data ?? [];
                  final query = _searchController.text.toLowerCase();

                  final filtered = query.isEmpty
                      ? attendances
                      : attendances.where((item) {
                          final name =
                              item['service_name']?.toString().toLowerCase() ??
                                  '';
                          final date =
                              item['date']?.toString().toLowerCase() ?? '';
                          return name.contains(query) || date.contains(query);
                        }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No attendance found."));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final date = DateFormat('MMMM d, y').format(
                        DateTime.tryParse(item['date']?.toString() ?? '') ??
                            DateTime.now(),
                      );

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Get.to(() => ServiceScreen(attendanceData: item));
                          },
                          child: ListTile(
                            title: Text(
                              item['service_name'] ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              date,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ServiceScreen());
        },
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
