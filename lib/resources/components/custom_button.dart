import 'package:flutter/material.dart';

import '../app_color.dart';

Widget customButton({
  required BuildContext context,
  bool isEnabled = false,
  double minWidth = 100.0,
  required void Function()? onPressed,
  required String title,
}) {
  final theme = Theme.of(context);

  return InkWell(
    onTap: isEnabled ? onPressed : null,
    child: Container(
      // width: minWidth,
      // height: 50,
      decoration: ShapeDecoration(
        color: AppColor.whiteColor.withOpacity(isEnabled ? 1 : 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(3),
          ),
        ),
      ),
      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16),
        child: Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColor.callToActionColor.withOpacity(isEnabled ? 1 : 0.65),
            fontSize: 14,
          ),
        ),
      ),
    ),
  );

  // ButtonTheme(
  //   minWidth: minWidth,
  //   shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(3))),
  //   buttonColor: AppColor.whiteColor.withOpacity(isEnabled ? 1 : 0.5),
  //   disabledColor: AppColor.whiteColor.withOpacity(.5),
  //   // disabledColor: AppColor.whiteColor.withOpacity(.3),

  //   height: 36,
  //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //   child: ElevatedButton(
  //     onPressed: isEnabled ? onPressed : () {},
  //     child: Text(title,
  //         style: theme.textTheme.headlineSmall?.copyWith(
  //             color:
  //                 AppColor.callToActionColor.withOpacity(isEnabled ? 1 : 0.65),
  //             fontSize: 12)),
  //   ),
  // );
}
