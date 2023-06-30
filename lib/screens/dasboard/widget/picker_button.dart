import 'package:fittle_ai/screens/dasboard/widget/picker_list.dart';
import 'package:flutter/material.dart';

import '../../../resources/resources.dart';

class PickerButton extends StatelessWidget {
  const PickerButton({
    super.key,
    required this.title,
    required this.selectedQuantity,
    required this.onSave,
  });
  final String title;
  final int selectedQuantity;
  final void Function(int) onSave;

  @override
  Widget build(BuildContext context) {
    int selectedQty = selectedQuantity;
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              content: PickFromList(
                incomingQuantity: selectedQuantity,
                title: title,
                onSelect: (selectedQuantity) {
                  selectedQty = selectedQuantity;
                },
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    height: 26,
                    width: 78,
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: m12_600LBlackTextStyle,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onSave(selectedQty);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColor.progressBarColor,
                    ),
                    height: 26,
                    width: 78,
                    child: Center(
                      child: Text(
                        "Save",
                        style: m12_600WhiteTextStyle,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: AppColor.f3f3f3Color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: "Qty: ",
                style: p10_400LBlackTextStyle,
                children: [
                  TextSpan(
                    text: "${selectedQuantity.toString()}gm",
                    style: p10_400OffBlackTextStyle,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
