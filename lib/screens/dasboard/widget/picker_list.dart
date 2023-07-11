import 'package:fittle_ai/utils/constants.dart';
import 'package:flutter/cupertino.dart';

import '../../../resources/resources.dart';

class PickFromList extends StatelessWidget {
  const PickFromList({
    super.key,
    required this.title,
    required this.incomingQuantity,
    required this.onSelect,
  });
  final String title;
  final int incomingQuantity;
  final void Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    int selectedQty = incomingQuantity;
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: p12_500BlackTextStyle,
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(child: SizedBox(width: 100, child: items(selectedQty))),
        ],
      ),
    );
  }

  Widget items(int selectedQty) {
    return CupertinoPicker.builder(
      scrollController: FixedExtentScrollController(
          initialItem: Constant.quantities.indexOf(incomingQuantity)),
      diameterRatio: 2,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: AppColor.progressBarColor.withOpacity(.3),
      ),
      itemExtent: 38,
      squeeze: 1,
      onSelectedItemChanged: (index) {
        selectedQty = Constant.quantities[index];
        onSelect(selectedQty);
      },
      itemBuilder: (context, index) => Center(
        child: Text(
            Constant.quantities.map((e) => e.toString()).toList()[index],
            style: p10_400BlackTextStyle),
      ),
      childCount: Constant.quantities.length,
    );
  }
}
