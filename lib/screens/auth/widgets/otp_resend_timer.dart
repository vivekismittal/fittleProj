import 'dart:async';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:flutter/material.dart';

class OtpTimer extends StatefulWidget {
  const OtpTimer({super.key, required this.resendButtonCallback});
  final void Function() resendButtonCallback;

  @override
  State<OtpTimer> createState() => OtpTimerState();
}

class OtpTimerState extends State<OtpTimer> {
  Timer? _timer;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _secondsRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          // Call the callback function or perform desired actions
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _secondsRemaining == 0
        ? TextButton(
            onPressed: widget.resendButtonCallback,
            child: Text(
              "Resend OTP",
              style: p14_500WhiteTextStyle.copyWith(
                  decoration: TextDecoration.underline),
            ),
          )
        : RichText(
            text: TextSpan(
              text: "Resend OTP in ",
              style: p10_400ParaTextStyle.copyWith(fontSize: 14),
              children: [
                TextSpan(
                  text:
                      "00:${_secondsRemaining < 10 ? "0$_secondsRemaining" : _secondsRemaining}",
                  style: p14_500WhiteTextStyle.copyWith(
                      decoration: TextDecoration.underline),
                )
              ],
            ),
          );
  }
}
