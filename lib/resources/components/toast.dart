import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:flutter/material.dart';

class Toast extends StatelessWidget {
  final String message;

  const Toast({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(16.0),
        color: AppColor.offBlackColor.withOpacity(.8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            message,
            style: m12_600WhiteTextStyle.copyWith(fontSize: 16),
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Toast(message: message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
