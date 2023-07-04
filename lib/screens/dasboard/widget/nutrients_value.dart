import 'package:flutter/material.dart';

import '../../../resources/resources.dart';

class NutrientsValue extends StatelessWidget {
  const NutrientsValue({
    super.key,
    required this.title,
    required this.asset,
    required this.value,
  });

  final String title;
  final String asset;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 30,
          child: Image.asset(asset,fit: BoxFit.fill,),
          
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            text: "${value.round()} g\n",
            style: p10_500OffBlackTextStyle,
            children: [TextSpan(text: title, style: p8_400LBlackTextStyle)],
          ),
        ),
      ],
    );
  }
}
