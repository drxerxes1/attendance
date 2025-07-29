import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance/helper/global.dart';

// Model for suggestion
class MemberSuggestion {
  final String id;
  final String name;

  MemberSuggestion({required this.id, required this.name});
}

class CustomAutocompleteTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final String collection;
  final String field;
  final bool isEnabled;
  final ValueChanged<String?> onSelectedId; // <-- new callback

  const CustomAutocompleteTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.collection,
    required this.field,
    required this.onSelectedId,
    this.isEnabled = true,
  });

  @override
  State<CustomAutocompleteTextfield> createState() =>
      _CustomAutocompleteTextfieldState();
}

class _CustomAutocompleteTextfieldState
    extends State<CustomAutocompleteTextfield> {
  List<MemberSuggestion> _suggestions = [];

  Future<List<MemberSuggestion>> fetchSuggestions(String query) async {
    if (query.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection(widget.collection)
        .where(widget.field, isGreaterThanOrEqualTo: query)
        .where(widget.field, isLessThan: '${query}z')
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => MemberSuggestion(
              id: doc.id,
              name: doc[widget.field],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: size.width * 0.035),
        ),
        SizedBox(height: size.width * 0.02),
        Autocomplete<MemberSuggestion>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            _suggestions = await fetchSuggestions(textEditingValue.text);
            return _suggestions;
          },
          displayStringForOption: (option) => option.name,
          onSelected: (MemberSuggestion selection) {
            widget.controller.text = selection.name;
            widget.onSelectedId(selection.id); // Return the ID
          },
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            // Sync external controller with internal
            textEditingController.text = widget.controller.text;
            textEditingController.selection = widget.controller.selection;

            textEditingController.addListener(() {
              widget.controller
                ..text = textEditingController.text
                ..selection = textEditingController.selection;

              // Check if input matches one of the suggestions
              final match = _suggestions.firstWhere(
                (s) => s.name == textEditingController.text,
                orElse: () => MemberSuggestion(id: "NonMember", name: ""),
              );

              widget.onSelectedId(
                  match.name.isNotEmpty ? match.id : "NonMember");
            });

            return SizedBox(
              height: 35,
              child: TextField(
                controller: textEditingController,
                focusNode: focusNode,
                enabled: widget.isEnabled,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: widget.isEnabled ? Colors.white : Colors.white54,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.white30,
                    fontSize: size.width * 0.035,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.white30,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: Colors.white30,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
