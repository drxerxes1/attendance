import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const appName = 'Attendance';

late Size mq;

const primaryColor = Color(0xFFfed22b);

// firebase options
final androidApiKey = dotenv.env['GOOGLE_API_KEY_ANDROID'].toString();
final iosApiKey = dotenv.env['GOOGLE_API_KEY_IOS'].toString();
