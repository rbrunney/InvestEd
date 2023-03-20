import 'package:flutter/material.dart';
import 'package:invested/util/widget/data/price_history/period_view/period_picker_button.dart';

class PeriodChoice extends StatefulWidget {
  String gainPeriod;
  PeriodChoice({
    Key? key,
    this.gainPeriod = ""
  }) : super(key: key);

  @override
  State<PeriodChoice> createState() => _PeriodChoicePickerState();
}

class _PeriodChoicePickerState extends State<PeriodChoice> {
  String activePicker = "1D";

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}