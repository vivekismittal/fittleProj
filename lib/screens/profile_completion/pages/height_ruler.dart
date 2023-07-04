import '../../../resources/resources.dart';
import 'package:fittle_ai/screens/profile_completion/screen_model.dart/profile_completion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../widgets/ruler.dart';

class HeightRulerPage extends StatefulWidget {
  const HeightRulerPage({super.key, required this.heightRulerModel});

  final HeightRulerModel heightRulerModel;
  @override
  State<HeightRulerPage> createState() => _HeightRulerPageState();
}

class _HeightRulerPageState extends State<HeightRulerPage> {
  late int intervals;
  @override
  void initState() {
    context.read<ProfileBloc>().add(
        ProfileEnabledProceedEvent(ProfileCompletionData.heightRulerIndex));
    intervals = 12;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(((widget.heightRulerModel.height % 1) * intervals).round());
    int ft = widget.heightRulerModel.height.toInt();
    int inch = ((widget.heightRulerModel.height % 1) * intervals).round();
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: "${ft}",
            style: m24_600WhiteTextStyle,
            children: [
              TextSpan(
                text: "ft",
                style: p16_500WhiteTextStyle,
              ),
              TextSpan(
                text: " ${inch}",
                style: m24_600WhiteTextStyle,
              ),
               TextSpan(
                text: "in",
                style: p16_500WhiteTextStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Container(
          height: 300,
          width: 144,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppColor.progressBarColor.withOpacity(.9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Ruler(
                initialValue: widget.heightRulerModel.height,
                intervals: intervals,
                max: 10,
                min: 3,
                valueTransform: 1,
                suffix: "’ 0”",
                onSelectedItemChanged: (val) {
                  setState(() {
                    widget.heightRulerModel.height = val;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
