import 'package:flutter/material.dart';

import '../../app_color.dart';

class BaseTextButton extends StatelessWidget {
  const BaseTextButton({
    super.key,
    this.onPressed,
    required this.title,
    this.isFilled = false,
    required this.isActive,
  });

  final VoidCallback? onPressed;
  final String title;
  final bool isFilled;
  final bool isActive;
  final double borderRadius = 3.0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MaterialButton(
        key: key,
        elevation: 0,
        color: isActive
            ? isFilled
                ? AppColor.whiteColor
                : null
            : AppColor.whiteColor.withOpacity(0.65),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: isFilled
              ? BorderSide.none
              : const BorderSide(color: AppColor.whiteParaColor, width: 1),
        ),
        onPressed: isActive ? onPressed : () {},
        child: Text(
          title.toUpperCase(),
          style: theme.textTheme.headlineSmall?.copyWith(
              height: 16 / 12,
              color: isFilled
                  ? isActive
                      ? AppColor.callToActionColor
                      : AppColor.whiteColor
                  : AppColor.whiteColor,
              fontSize: 12),
        ));
  }
}
