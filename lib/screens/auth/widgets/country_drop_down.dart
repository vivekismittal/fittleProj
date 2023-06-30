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
  int value = 0;
  @override
  void initState() {
    // TODO: implement initState
    _countryCode = widget.countryCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(0)),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, size: 20),
      dropdownColor: widget.color.withOpacity(.2),
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
      value: value,
    );
  }

  DropdownMenuItem<dynamic> countryDropDownMenuItem(
      Country country, BuildContext context, int value, Color color) {
    final theme = Theme.of(context);

    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                country.flag,
                style: const TextStyle(fontSize: 24),
              )
              // icon,
              ),
          Expanded(
            child: Text(
              " ${country.dialCode}",
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
