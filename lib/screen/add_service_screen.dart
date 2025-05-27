import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/widgets/custom_app_bar.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  @override
  Widget build(BuildContext context) {
    final serviceController = TextEditingController();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Service'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
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
      ),
    );
  }
}
