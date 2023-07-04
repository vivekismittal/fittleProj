import '../../../resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/event/profile_event.dart';
import '../../../bloc/profile_bloc.dart';
import '../screen_model.dart/profile_completion_data.dart';

class SlidingCalender extends StatefulWidget {
  const SlidingCalender({super.key, required this.howOldModel});

  final HowOldModel howOldModel;
  @override
  State<SlidingCalender> createState() => _SlidingCalenderState();
}

class _SlidingCalenderState extends State<SlidingCalender> {
  final DateTime _todayDate = DateTime.now();
  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedYear;
  late int startingYear;

  List<String> get getMonthInYear {
    if (_selectedYear == _todayDate.year) {
      return HowOldModel.totalMonths.sublist(0, _todayDate.month);
    }
    return HowOldModel.totalMonths;
  }

  int get getDaysInMonth {
    if (_selectedYear == _todayDate.year &&
        _selectedMonth == _todayDate.month) {
      return _todayDate.day;
    }
    return DateTime(_selectedYear, _selectedMonth + 1, 0).day;
  }

  @override
  void initState() {
    _selectedDay = widget.howOldModel.selectedDay;
    _selectedMonth = widget.howOldModel.selectedMonth;
    _selectedYear = widget.howOldModel.selectedYear;
    startingYear = 1900;
    context.read<ProfileBloc>().add(
        ProfileEnabledProceedEvent(ProfileCompletionData.howOldModelIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) {
            int length;
            int initialItem;
            if (index == 0) {
              length = getMonthInYear.length;
              initialItem = _selectedMonth - 1;
            } else if (index == 1) {
              length = getDaysInMonth;
              initialItem = _selectedDay - 1;
            } else {
              length = _todayDate.year - startingYear + 1;
              initialItem = _selectedYear - startingYear;
            }
            return Expanded(
              child: SizedBox(
                height: 256,
                child: CupertinoPicker.builder(
                  scrollController:
                      FixedExtentScrollController(initialItem: initialItem),
                  diameterRatio: 2,
                  selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                      background: AppColor.whiteColor.withOpacity(.3)),
                  itemExtent: 38,
                  squeeze: 1,
                  onSelectedItemChanged: (val) {
                    setState(() {
                      if (index == 0) {
                        _selectedMonth = val + 1;
                        widget.howOldModel.selectedMonth = _selectedMonth;
                      } else if (index == 1) {
                        _selectedDay = val + 1;
                        widget.howOldModel.selectedDay = _selectedDay;
                      } else {
                        _selectedYear = startingYear + val;
                        widget.howOldModel.selectedYear = _selectedYear;
                      }
                    });
                  },
                  itemBuilder: (context, itemIndex) => Center(
                    child: Text(
                      index == 0
                          ? getMonthInYear[itemIndex]
                          : index == 1
                              ? (itemIndex + 1).toString()
                              : (startingYear + itemIndex).toString(),
                      style: p12_500WhiteTextStyle,
                    ),
                  ),
                  childCount: length,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
