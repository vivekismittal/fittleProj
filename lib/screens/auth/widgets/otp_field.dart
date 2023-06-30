import 'package:flutter/material.dart';

import '../../../common/form_input_field.dart';
import '../../../resources/components/texts/custom_text.dart';

typedef OtpCompletedCallback = void Function(String otp);

class InputOtpField extends StatefulWidget {
  const InputOtpField(
      {super.key,
      required this.onOtpCompleted,
      required this.otpLength,
      required this.onOtpIncompleted});
  final OtpCompletedCallback onOtpCompleted;
  final OtpCompletedCallback onOtpIncompleted;

  final int otpLength;
  @override
  State<InputOtpField> createState() => _InputOtpFieldState();
}

class _InputOtpFieldState extends State<InputOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();

    // Initialize the list of controllers and focus nodes
    _controllers =
        List.generate(widget.otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    // Dispose the controllers and focus nodes
    for (int i = 0; i < widget.otpLength; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }

    super.dispose();
  }

  void _onOtpTextChanged(String value, int index) {
    // Update the OTP value in the corresponding controller
    _controllers[index].text = value;

    if (value.isNotEmpty) {
      // Move focus to the next field if the current field is filled
      if (index < widget.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();

        // Check if all OTP fields are filled
        bool isOtpComplete = true;
        for (int i = 0; i < widget.otpLength; i++) {
          if (_controllers[i].text.isEmpty) {
            isOtpComplete = false;
            break;
          }
        }

        if (isOtpComplete) {
          // Get the completed OTP value
          String completedOtp =
              _controllers.map((controller) => controller.text).join();

          // Invoke the onOtpCompleted function with the completed OTP value
          widget.onOtpCompleted(completedOtp);
        } else {
          widget.onOtpIncompleted("");
        }
      }
    } else {
      // Move focus to the previous field if the current field is empty
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.otpLength,
        (index) => SizedBox(
          width: 36,
          height: 36,
          child: FormInputField(
            label: InputFieldsLabel.otp,
            isFilled: false,
            textAlign: TextAlign.center,
            showCursor: false,
            style: p12_500WhiteTextStyle,
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            autoFocus: index == 0,
            onChanged: (value) {
              _onOtpTextChanged(value, index);
            },
          ),
        ),
      ),
    );
  }
}
