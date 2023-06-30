import 'package:fittle_ai/resources/app_color.dart';
import 'package:flutter/material.dart';

Future<void> selectDate(BuildContext context, DateTime initialDate,
    void Function(DateTime) onDatePicked) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDatePickerMode: DatePickerMode.year,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: AppColor.callToActionColor, 
          hintColor: AppColor.outlineColor, 
          colorScheme: const ColorScheme.light(
            primary: AppColor.callToActionColor,
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    onDatePicked(picked);
  }
}
