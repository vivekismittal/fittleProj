import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../resources/resources.dart';

import '../../../resources/components/show_date_picker.dart';

class DateSlider extends StatelessWidget {
  const DateSlider({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onDateChanged,
    this.isBackButtonVisible = false,
    this.isDayBreakVisible = true,
    this.dayBreakList = const [],
    this.selectedDayBreak = "",
    this.onDayBreakChange,
    this.color = AppColor.progressBarColor,
  });

  final bool isBackButtonVisible;
  final bool isDayBreakVisible;
  final String title;
  final DateTime selectedDate;
  final List<String> dayBreakList;
  final void Function(DateTime) onDateChanged;
  final String selectedDayBreak;
  final void Function(String)? onDayBreakChange;
  final Color color;
  String getMMMYYYY(DateTime date) {
    var month = DateFormat('MMMM').format(date);
    return "$month ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller =
        ScrollController(initialScrollOffset: (selectedDate.day - 3) * 52);
    String subTitle = getMMMYYYY(selectedDate);
    int totalDays = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22),
          child: Row(
            children: [
              if (isBackButtonVisible)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
              if (isBackButtonVisible) const SizedBox(width: 14),
              RichText(
                text: TextSpan(
                  text: title,
                  style: p12_400BlackTextStyle,
                  children: [
                    TextSpan(
                      text: "\n$subTitle",
                      style: p10_400OffBlackTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        // fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  selectDate(context, DateTime.now(), (dateSelected) {
                    onDateChanged(dateSelected);
                  });
                },
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(color: AppColor.outlineColor, width: .5)),
                  child: const Center(
                    child: Icon(
                      Icons.calendar_month,
                      color: AppColor.outlineColor,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          height: 60,
          child: ListView.builder(
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: totalDays,
            itemBuilder: (context, index) =>
                selectableDayCard(context, index, selectedDate, (date) {
              onDateChanged(date);
            }, color),
          ),
        ),
        if (isDayBreakVisible)
          Container(
            color: AppColor.f9f9f9Color,
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dayBreakList.length,
              itemBuilder: (context, index) => Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: dayBreakButton(
                  onClick: () {
                    if (onDayBreakChange != null) {
                      onDayBreakChange!(dayBreakList[index]);
                    }
                  },
                  title: dayBreakList[index],
                  isActive: selectedDayBreak == dayBreakList[index],
                ),
              ),
            ),
    
          ),
      ],
    );
  }

  Widget dayBreakButton({
    required String title,
    required void Function() onClick,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: isActive ? color : null,
        ),
        padding: const EdgeInsets.all(6),
        height: 24,
        child: Text(
          title,
          style: isActive ? p8_500WhiteTextStyle : p8_400OffBlackTextStyle,
        ),
      ),
    );
  }

  Widget selectableDayCard(
      BuildContext context,
      int index,
      DateTime selectedDate,
      void Function(DateTime date) onDateChanged,
      Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap:
            // index + 1 > DateTime.now().day
            //     ? null
            //     :
            () {
          onDateChanged(
              DateTime(selectedDate.year, selectedDate.month, index + 1));
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: selectedDate.day == index + 1
                      ? color
                      : AppColor.whiteParaColor,
                  border: (DateTime.now().day == index + 1) &&
                          (DateTime.now().month == selectedDate.month) &&
                          (DateTime.now().year == selectedDate.year)
                      ? Border.all(color: color)
                      : null),
              // height: 46,
              // width: 40,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.E().format(DateTime(
                        selectedDate.year, selectedDate.month, index + 1)),
                    style: p8_400LBlackTextStyle.copyWith(
                      color: selectedDate.day == index + 1
                          ? AppColor.whiteColor
                          : AppColor.lightBlackColor,
                    ),
                  ),
                  Text(
                    (index + 1).toString(),
                    style: p8_400LBlackTextStyle.copyWith(
                      color: selectedDate.day == index + 1
                          ? AppColor.whiteColor
                          : AppColor.lightBlackColor,
                    ),
                  ),
                ],
              ),
            ),
            if ((DateTime.now().day == index + 1) &&
                (DateTime.now().month == selectedDate.month) &&
                (DateTime.now().year == selectedDate.year))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.circle,
                  color: color,
                  size: 4,
                ),
              )
          ],
        ),
      ),
    );
  }
}
