import 'package:attendance/helper/global.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddInformation extends StatefulWidget {
  const AddInformation({super.key});

  @override
  State<AddInformation> createState() => _AddInformationState();
}

class _AddInformationState extends State<AddInformation> {
  final TextEditingController preacherController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController scriptureController = TextEditingController();
  final TextEditingController worshipLeaderController = TextEditingController();
  final TextEditingController songLeaderController = TextEditingController();

  final TextEditingController songController = TextEditingController();
  final List<String> songs = [];

  void _addSong() {
    final text = songController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        songs.add(text);
        songController.clear();
      });
    }
  }

  void _removeSong(int index) {
    setState(() {
      songs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: mq.width * 0.05),
          const Text('Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

          // Sermon Section
          SizedBox(height: mq.width * 0.05),
          const Text('Sermon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: preacherController,
            hintText: 'Preacher',
            label: 'Preacher',
          ),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: titleController,
            hintText: 'Title',
            label: 'Title',
          ),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: scriptureController,
            hintText: 'Scripture',
            label: 'Scripture',
          ),
          SizedBox(height: mq.width * 0.05),

          // Praise and Worship Section
          const Text('Praise and Worship',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: worshipLeaderController,
            hintText: 'Worship Leader',
            label: 'Worship Leader',
          ),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: songLeaderController,
            hintText: 'Song Leader',
            label: 'Song Leader',
          ),
          SizedBox(height: mq.width * 0.02),
          Text('Songs: ', style: TextStyle(fontSize: mq.width * 0.035)),
          SizedBox(height: mq.width * 0.02),

          // List of songs
          ...songs.asMap().entries.map((entry) {
            int index = entry.key;
            String song = entry.value;
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
                    child: Text(song,
                        style: TextStyle(
                            fontSize: mq.width * 0.035, color: Colors.white)),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => _removeSong(index),
                  ),
                ],
              ),
            );
          }),

          // TextField to add a new song
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
                    controller: songController,
                    decoration: InputDecoration(
                      hintText: 'Song Title Here',
                      hintStyle: TextStyle(
                          color: Colors.white30, fontSize: mq.width * 0.035),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12.5),
                    ),
                    style: TextStyle(
                        color: Colors.white, fontSize: mq.width * 0.035),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => songController.clear(),
                ),
              ],
            ),
          ),

          // Add Song Button
          GestureDetector(
            onTap: _addSong,
            child: Container(
              height: mq.width * 0.1,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800),
                borderRadius: BorderRadius.circular(5),
              ),
              width: double.infinity,
              child: Center(
                child: Text(
                  '+ Add Song',
                  style: TextStyle(
                      fontSize: mq.width * 0.035, color: Colors.white),
                ),
              ),
            ),
          ),

          SizedBox(height: mq.height * 0.05),
        ],
      ),
    );
  }
}
