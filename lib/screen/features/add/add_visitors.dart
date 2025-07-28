import 'package:attendance/helper/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';

class AddVisitors extends StatefulWidget {
  const AddVisitors({super.key});

  @override
  State<AddVisitors> createState() => _AddVisitorsState();
}

class _AddVisitorsState extends State<AddVisitors> {
  final List<String> visitors = [];
  final TextEditingController visitorController = TextEditingController();

  void _addVisitor() {
    final text = visitorController.text.trim();
    if (text.isNotEmpty) {
      final isDuplicate = visitors
          .any((visitor) => visitor.toLowerCase() == text.toLowerCase());
      if (isDuplicate) {
        CustomDialog.error('Visitor already exists');
        return;
      }

      setState(() {
        visitors.add(text);
        visitorController.clear();
      });
    }
  }

  void _removeVisitor(int index) {
    setState(() {
      visitors.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: mq.width * 0.05),
          const Text('Visitors',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: mq.width * 0.05),
          // List of visitors
          ...visitors.asMap().entries.map((entry) {
            int index = entry.key;
            String visitor = entry.value;
            return Container(
              height: mq.width * 0.1,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      visitor,
                      style: TextStyle(
                          fontSize: mq.width * 0.035, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () => _removeVisitor(index),
                  ),
                ],
              ),
            );
          }),

          // TextField to add a new visitor
          Container(
            height: mq.width * 0.1,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: visitorController,
                    decoration: InputDecoration(
                      hintText: 'Add new visitor here',
                      hintStyle: TextStyle(
                          color: Colors.white30, fontSize: mq.width * 0.035),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: TextStyle(
                        color: Colors.white, fontSize: mq.width * 0.035),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red, size: 20),
                  onPressed: () => visitorController.clear(),
                ),
              ],
            ),
          ),

          // Add Visitor Button
          GestureDetector(
            onTap: _addVisitor,
            child: Container(
              height: mq.width * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  '+ Add Visitor',
                  style: TextStyle(
                      fontSize: mq.width * 0.035, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
