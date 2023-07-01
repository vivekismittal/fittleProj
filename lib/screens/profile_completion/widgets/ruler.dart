import 'dart:math';

import 'package:flutter/material.dart';

import '../../../resources/resources.dart';


class Ruler extends StatelessWidget {
  const Ruler({
    super.key,
    required this.initialValue,
    required this.intervals,
    required this.min,
    required this.max,
    required this.valueTransform,
    this.suffix,
    required this.onSelectedItemChanged,
    this.isHorizontal = false,
  });

  final double initialValue;
  final int intervals;
  final int valueTransform;
  final int min;
  final int max;
  final String? suffix;
  final void Function(double) onSelectedItemChanged;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    int count = ((max - min) * intervals) + 1;
    int selectedIndex = (initialValue - min) * intervals ~/ valueTransform;
    ScrollController scrollController =
        FixedExtentScrollController(initialItem: selectedIndex);
    return SizedBox(
      height: 260,
      width: 110,
      child: ListWheelScrollView.useDelegate(
        
        controller: scrollController,
        itemExtent: 14,
        onSelectedItemChanged: (val) {
          onSelectedItemChanged((val * valueTransform / intervals) + min);
        },
        squeeze: 2,
        childDelegate: ListWheelChildBuilderDelegate(
          
          childCount: count,
          builder: (context, index) {
            double width;
            if (index % intervals == 0) {
              width = 46;
            } else if (index % (intervals / 2) == 0) {
              width = 34;
            } else {
              width = 22;
            }
            double opacity;
            int gap = (selectedIndex - index).abs();
            if (gap < 20) {
              opacity = (20 - gap) / 20;
            } else {
              opacity = 0.0;
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 1,
                  width: width,
                  color: AppColor.whiteColor.withOpacity(opacity),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    child: Transform.rotate(
                      angle: isHorizontal ? pi / 2 : 0,
                      child: Text(
                        index % intervals == 0
                            ? "${((index * valueTransform / intervals) + min).toInt()}$suffix"
                            : "",
                        style: p12_500WhiteTextStyle.copyWith(
                            color:
                                AppColor.whiteParaColor.withOpacity(opacity)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
