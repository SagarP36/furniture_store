import 'package:flutter/material.dart';
import 'package:furniture_store/model/product.dart';
import 'package:get/get.dart';

class CustomDropdown extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final onChanged;
  final String? value;
  final String label;
  // ignore: prefer_typing_uninitialized_variables
  final items;
  const CustomDropdown(
      {Key? key,
      this.onChanged,
      this.label = "Grade",
      required this.items,
      this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //custom dropdown
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: DropdownButton<String>(
            value: value,
            hint: Text(label, style: const TextStyle(color: Colors.grey)),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 0,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) => onChanged(newValue),
            isExpanded: true,
            items: items.map<DropdownMenuItem<String>>((Product grade) {
              return DropdownMenuItem<String>(
                value: grade.name,
                child: Text(grade.name),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
