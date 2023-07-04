import 'package:fittle_ai/resources/app_color.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.numberOfPages,
    required this.currentIndex,
  });

  final int numberOfPages;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        numberOfPages,
        (index) => EachIndicator(
          index: index,
          currentIndex: currentIndex,
        ),
      ),
    );
  }
}

class EachIndicator extends StatelessWidget {
  const EachIndicator({
    super.key,
    required this.index,
    required this.currentIndex,
  });
  final int index;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: index == currentIndex ? 54 : 28,
      decoration: BoxDecoration(
        color: index > currentIndex
            ? AppColor.whiteParaColor.withOpacity(.5)
            : AppColor.whiteColor,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
