import 'package:fittle_ai/resources/app_color.dart';
import 'package:fittle_ai/resources/components/texts/custom_text.dart';
import 'package:flutter/material.dart';
import './../utils/extensions.dart';

enum InputFieldsLabel { mobile, otp, name, email, foodSearch, workout,normal}

class FormInputField extends StatelessWidget {
  const FormInputField({
    Key? key,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.prefixWidget,
    this.suffixWidget,
    this.trailingWidget,
    this.canExpand = false,
    this.errorText = 'Required field',
    this.hintText,
    this.onChanged,
    this.autoFocus = false,
    this.isReadOnly = false,
    this.intialValue = '',
    this.hintStyle,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 4,
    ),
    this.keyboardType,
    this.style,
    this.isFilled = true,
    this.textAlign = TextAlign.start,
    this.showCursor,
    this.maxLength,
    this.focusNode,
    required this.label,
    this.radius = 3,
    this.fillColor,
    this.cursorColor, this.enabled,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextStyle? hintStyle;
  final EdgeInsets contentPadding;
  final TextInputType? keyboardType;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Widget? trailingWidget;
  final bool canExpand;
  final String? errorText;
  final String? hintText;
  final Function(String)? onChanged;
  final bool autoFocus;
  final bool isReadOnly;
  final String intialValue;
  final TextStyle? style;
  final bool isFilled;
  final TextAlign textAlign;
  final bool? showCursor;
  final int? maxLength;
  final FocusNode? focusNode;
  final InputFieldsLabel label;
  final double radius;
  final Color? fillColor;
  final Color? cursorColor;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 120,
        minHeight: 36,
        minWidth: 36,
      ),
      child: TextFormField(
        enabled: enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        maxLength: maxLength,
        keyboardType: keyboardType,
        controller: controller,
        validator: (value) {
          if (label == InputFieldsLabel.mobile &&
              value != null &&
              value.isNotEmpty) {
            if (!value.isNumeric()) {
              return "Invalid Mobile";
            }
            return null;
          }
          return null;
        },
        autofocus: autoFocus,
        enableSuggestions: true,
        enableInteractiveSelection: true,
        maxLines: canExpand == false ? 1 : 4,
        minLines: 1,
        textInputAction: textInputAction,
        onChanged: onChanged,
        style: style ?? theme.textTheme.labelLarge,
        textAlign: textAlign,
        showCursor: showCursor,
        cursorColor: cursorColor,
        decoration: InputDecoration(
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.errorColor,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          errorStyle: p10_400ErrorTextStyle,
          counterText: "",
          contentPadding: contentPadding,
          fillColor: fillColor ?? AppColor.whiteColor.withOpacity(0.3),
          border: OutlineInputBorder(
            borderSide: isFilled
                ? BorderSide.none
                : const BorderSide(
                    color: AppColor.whiteParaColor,
                    width: .5,
                  ),
            borderRadius: BorderRadius.circular(radius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: isFilled
                ? BorderSide.none
                : const BorderSide(
                    color: AppColor.whiteParaColor,
                    width: .5,
                  ),
            borderRadius: BorderRadius.circular(radius),
          ),
          filled: isFilled,
          hintText: hintText,
          hintStyle: hintStyle ??
              theme.textTheme.bodySmall
                  ?.copyWith(color: AppColor.whiteParaColor.withOpacity(.85)),
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
        ),
      ),
    );
  }
}
