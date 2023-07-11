import 'package:flutter/material.dart';

import '../../../resources/app_color.dart';
import '../../../utils/countries.dart';

class CountryDropDown extends StatefulWidget {
  const CountryDropDown(
      {super.key,
      required this.onChanged,
      required this.countryCode,
      this.color = AppColor.whiteColor});
  final void Function(String) onChanged;
  final String countryCode;
  final Color color;

  @override
  State<CountryDropDown> createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {
  late String _countryCode;
  late Country country;
  int? value = 0;
  @override
  void initState() {
    _countryCode = widget.countryCode;
    country = countries.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  Container(
        //   height: 48,
        //   decoration: BoxDecoration(
        //       color: AppColor.whiteColor.withOpacity(0.3),
        //       borderRadius: BorderRadius.circular(3)),
        //   child: Row(
        //     children: [
        //       Padding(
        //           padding: const EdgeInsets.only(left: 4),
        //           child: Text(
        //             country.flag,
        //             style: const TextStyle(fontSize: 24),
        //           )
        //           // icon,
        //           ),
        //       Expanded(
        //         child: Text(
        //           " ${country.dialCode}",
        //           style: p12_500WhiteTextStyle,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //       ),
        //       PopupMenuButton(
        //           position: PopupMenuPosition.under,
        //           color: AppColor.progressBarColor,
        //           child: const Icon(
        //             Icons.arrow_drop_down_outlined,
        //             color: AppColor.whiteColor,
        //           ),
        //           onSelected: (val) {
        //             _countryCode = countries[val].dialCode;
        //             country = countries[val];
        //             setState(() => value = val);
        //             widget.onChanged(_countryCode);
        //           },
        //           itemBuilder: (ctx) => List.generate(countries.length,
        //               (index) => _buildPopupMenuItem(countries[index], index))),
        //     ],
        //   ),
        // );

        DropdownButtonFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(0),
      ),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, size: 20),
      dropdownColor: AppColor.progressBarColor,
      iconEnabledColor: widget.color,
      alignment: Alignment.bottomCenter,
      menuMaxHeight: 400,
      items: countries.map((country) {
        return countryDropDownMenuItem(
            country, context, countries.indexOf(country), widget.color);
      }).toList(),
      onChanged: (val) {
        _countryCode = countries[val].dialCode;
        setState(() => value = val);
        widget.onChanged(_countryCode);
      },

      // onTap: () {
      //   setState(() {
      //     value = 0;
      //   });
      // },

      value: value,
    );
  }

  DropdownMenuItem<dynamic> countryDropDownMenuItem(
      Country country, BuildContext context, int value, Color color) {
    final theme = Theme.of(context);

    return DropdownMenuItem(
      value: value,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            country.flag,
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            " ${country.dialCode}",
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // PopupMenuItem _buildPopupMenuItem(Country country, int index) {
  //   return PopupMenuItem(
  //       value: index,
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Placeholder(
  //             child: Padding(
  //                 padding: const EdgeInsets.only(left: 4),
  //                 child: Text(
  //                   country.flag,
  //                   style: const TextStyle(fontSize: 24),
  //                 )
  //                 // icon,
  //                 ),
  //           ),
  //           Placeholder(
  //             child: Expanded(
  //               child: Text(
  //                 " ${country.dialCode}",
  //                 style: p12_500WhiteTextStyle,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}
