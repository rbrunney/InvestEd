import 'package:flutter/material.dart';
import 'package:invested/util/text/custom_text.dart';
import 'package:invested/util/global_styling.dart' as global_style;


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
          child: Column(
            children: [
              CustomText(
                  fontSize: widget.text == widget.activePicker ? 22 : 19,
                  text: widget.text,
                  color: widget.text == widget.activePicker ? const Color(global_style.blackAccentColor) : const Color(global_style.greenAccentTextColor)
              ),
              widget.text == widget.activePicker ? const SizedBox(
                height: 15,
                width: 35,
                child: Card(
                    color: Color(global_style.greenPrimaryColor)
                )
              ) : const Text("")
            ],
          )
        )
    );
  }
}