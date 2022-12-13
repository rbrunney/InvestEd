import 'package:flutter/material.dart';
import 'package:invested/pages/portfolio/period_picker_button.dart';

class PeriodChoicePicker extends StatefulWidget {
  String gainPeriod;
  PeriodChoicePicker({
    Key? key,
    this.gainPeriod = ""
  }) : super(key: key);

  @override
  State<PeriodChoicePicker> createState() => _PeriodChoicePickerState();
}

class _PeriodChoicePickerState extends State<PeriodChoicePicker> {
  String activePicker = "1D";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child:  Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          PeriodPickerButton(
            text: "1D",
            activePicker: activePicker,
            onPress: () {
              setState(() {
                widget.gainPeriod = "Today";
                activePicker = "1D";
              });
            },
          ),
          const Spacer(),
          PeriodPickerButton(
            text: "1W",
            activePicker: activePicker,
            onPress: () {
              setState(() {
                widget.gainPeriod = "Week";
                activePicker = "1W";
              });
            },
          ),
          const Spacer(),
          PeriodPickerButton(
            text: "1M",
            activePicker: activePicker,
            onPress: () {
              setState(() {
                widget.gainPeriod = "Month";
                activePicker = "1M";
              });
            },
          ),
          const Spacer(),
          PeriodPickerButton(
            text: "3M",
            activePicker: activePicker,
            onPress: () {
              setState(() {
                widget.gainPeriod = "3-Month";
                activePicker = "3M";
              });
            },
          ),
          const Spacer(),
          PeriodPickerButton(
            text: "YTD",
            activePicker: activePicker,
            onPress: () {
              setState(() {
                widget.gainPeriod = "Year-to-Date";
                activePicker = "YTD";
              });
            },
          ),
          const Spacer(),
          PeriodPickerButton(
            text: "ALL",
            activePicker: activePicker,
            onPress: () {
              setState(() {
                widget.gainPeriod = "All";
                activePicker = "ALL";
              });
            },
          ),
        ],
      )
    );
  }
}
