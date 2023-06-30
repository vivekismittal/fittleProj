import 'package:flutter/material.dart';

import '../../../resources/resources.dart';



class SelectableTile extends StatelessWidget {
  const SelectableTile({
    super.key,
    required this.isSelected,
    required this.title,
    this.icon,
    required this.onPressed,
  });

  final bool isSelected;
  final String title;
  final IconData? icon;
  final void Function(bool value) onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      padding: EdgeInsets.zero,
      splashColor: Colors.white10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      color: isSelected ? Colors.white : Colors.white38,
      onPressed: () => onPressed(!isSelected),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment:
              icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 22,
                color:
                    isSelected ? AppColor.blackTitleColor : AppColor.whiteColor,
              ),
            if (icon != null)
              const SizedBox(
                width: 8,
              ),
            Text(
              title,
              style: p12_500WhiteTextStyle.copyWith(
                color:
                    isSelected ? AppColor.blackTitleColor : AppColor.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
