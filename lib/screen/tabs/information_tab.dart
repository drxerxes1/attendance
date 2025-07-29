import 'package:attendance/helper/widgets/custom_dialog.dart';
import 'package:attendance/helper/widgets/custom_autocomplete_textfield.dart';
import 'package:attendance/helper/widgets/custom_text_field.dart';
import 'package:attendance/screen/controllers/service_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InformationTab extends StatelessWidget {
  const InformationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final controller = Get.find<ServiceController>();
    final TextEditingController songController = TextEditingController();

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
          CustomAutocompleteTextfield(
            controller: controller.preacherController,
            hintText: "Preacher",
            label: "Preacher",
            collection: "members",
            field: "name",
            onSelectedId: (id) {
              controller.selectedPreacherId.value = id ?? "NonMember";
            },
          ),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: controller.titleController,
            hintText: 'Title',
            label: 'Title',
          ),
          SizedBox(height: mq.width * 0.02),
          CustomTextField(
            controller: controller.scriptureController,
            hintText: 'Scripture',
            label: 'Scripture',
          ),
          SizedBox(height: mq.width * 0.05),

          // Praise and Worship Section
          const Text('Praise and Worship',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: mq.width * 0.02),
          CustomAutocompleteTextfield(
            controller: controller.worshipLeaderController,
            hintText: "Worship Leader",
            label: "Worship Leader",
            collection: "members",
            field: "name",
            onSelectedId: (id) {
              controller.selectedWorshipLeaderId.value = id ?? "NonMember";
            },
          ),
          SizedBox(height: mq.width * 0.02),
          CustomAutocompleteTextfield(
            controller: controller.songLeaderController,
            hintText: "Song Leader",
            label: "Song Leader",
            collection: "members",
            field: "name",
            onSelectedId: (id) {
              controller.selectedSongLeaderId.value = id ?? "NonMember";
            },
          ),
          SizedBox(height: mq.width * 0.02),
          Text('Songs: ', style: TextStyle(fontSize: mq.width * 0.035)),
          SizedBox(height: mq.width * 0.02),

          // List of songs
          Obx(() => Column(
                children: controller.songs.asMap().entries.map((entry) {
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
                                  fontSize: mq.width * 0.035,
                                  color: Colors.white)),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () => controller.removeSong(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )),

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
                    textCapitalization: TextCapitalization.words,
                    controller: songController,
                    decoration: InputDecoration(
                      hintText: 'Song Title Here',
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
                  icon: const Icon(
                    Icons.clear,
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
            onTap: () {
              final input = songController.text.trim();
              if (input.isEmpty) return;

              if (controller.isDuplicateSong(input)) {
                CustomDialog.error('Song already exists');
              } else {
                controller.addSong(input);
                songController.clear();
              }
            },
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
