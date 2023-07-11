import 'dart:math';

import '../../../resources/resources.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../widgets/ruler.dart';

class WeightRulerPage extends StatefulWidget {
  const WeightRulerPage({super.key, required this.weightRulerModel});

final WeightRulerModel weightRulerModel;
  @override
  State<WeightRulerPage> createState() => _WeightRulerPageState();
}

class _WeightRulerPageState extends State<WeightRulerPage> {
  
  late int intervals;
  @override
  void initState() {
    intervals = 10;
        context.read<ProfileBloc>().add(
        ProfileEnabledProceedEvent(ProfileCompletionData.weightRulerIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text:
                "${widget.weightRulerModel.weight % 10 == 0 ? widget.weightRulerModel.weight.toInt() : widget.weightRulerModel.weight}",
            style: m24_600WhiteTextStyle,
            children: [
              TextSpan(
                text: " kg",
                style: p16_500WhiteTextStyle,
              ),
            ],
          ),
        ),
        Transform.rotate(
          angle: -pi / 2,
          child: Container(
            height: 280,
            width: 144,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColor.progressBarColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ruler(
                  isHorizontal: true,
                  initialValue: widget.weightRulerModel.weight,
                  intervals: intervals,
                  max: 200,
                  min: 20,
                  valueTransform: 1,
                  suffix: "",
                  onSelectedItemChanged: (val) {
                    setState(() {
                      widget.weightRulerModel.weight = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
