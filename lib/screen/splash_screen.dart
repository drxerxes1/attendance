import 'package:attendance/helper/global.dart';
import 'package:attendance/screen/attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const AttendanceScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.all(mq.width * .05),
            child: Image.asset(
              'assets/images/ic_foreground.png',
              width: mq.width * 1,
            ),
          ),
        ),
      ),
    );
  }
}
