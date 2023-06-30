import 'package:flutter/material.dart';

import '../app_color.dart';

ButtonTheme customButton({
  required BuildContext context,
  bool isEnabled = false,
  double minWidth = 88.0,
  required void Function()? onPressed,
  required String title,
}) {
  final theme = Theme.of(context);

  return ButtonTheme(
    minWidth: minWidth,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3))),
    buttonColor: AppColor.whiteColor.withOpacity(isEnabled ? 1 : 0.5),
    // disabledColor: AppColor.whiteColor.withOpacity(.3),
    height: 36,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: ElevatedButton(
      onPressed: isEnabled ? onPressed : () {},
      child: Text(title,
          style: theme.textTheme.headlineSmall?.copyWith(
              color:
                  AppColor.callToActionColor.withOpacity(isEnabled ? 1 : 0.65),
              fontSize: 12)),
    ),
  );
}
