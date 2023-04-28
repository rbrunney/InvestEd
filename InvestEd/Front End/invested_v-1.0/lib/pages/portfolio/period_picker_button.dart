import 'package:flutter/material.dart';
import '../../util/custom_text.dart';


class PeriodPickerButton extends StatefulWidget {
  final String text;
  final String activePicker;
  final VoidCallback onPress;
  const PeriodPickerButton({
    Key? key,
    this.text = '',
    this.activePicker = '',
    required this.onPress
  }) : super(key: key);

  @override
  State<PeriodPickerButton> createState() => _PeriodPickerButtonState();
}

class _PeriodPickerButtonState extends State<PeriodPickerButton> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: widget.onPress,
        child: CustomText(
              text: widget.text,
              color: widget.text == widget.activePicker ? Colors.white : Colors.grey
        ),
      )
    );
  }
}
