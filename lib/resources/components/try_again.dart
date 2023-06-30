import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:fittle_ai/resources/components/toast.dart';
import 'package:fittle_ai/utils/constants.dart';
import 'package:flutter/material.dart';

class TryAgain extends StatelessWidget {
  const TryAgain({
    super.key,
    this.onTryAgain,
    this.message,  this.title =  "Its not you, Its us",
  });
  final void Function()? onTryAgain;
  final String? message;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Toast.show(context, message!);
      });
    }
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Image.asset(
              Constant.dissapointedEmojiPng,
              filterQuality: FilterQuality.high,
            ),
          ),
          // const SizedBox(height: 12),
          Text(
           title,
            style: m12_600BlackTextStyle,
          ),
          const SizedBox(height: 12),
          Material(
            elevation: 10,
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: onTryAgain,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.outlineColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  "TRY AGAIN",
                  style: m12_600LBlackTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
