import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  // Setting base properties
  final String hintText;
  final String labelText;
  final String? errorText;
  final bool hasSuffixIcon;
  bool isObscure;
  final double verticalMargin;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final IconData pressedSuffixIcon;
  final TextEditingController textController;

  CustomTextField({
        Key? key,
    this.hintText = '',
    this.labelText = '',
    this.errorText = '',
    this.hasSuffixIcon = false,
    this.isObscure = false,
    this.verticalMargin = 15,
    this.prefixIcon = Icons.abc_outlined,
    this.suffixIcon = Icons.abc_outlined,
    this.pressedSuffixIcon = Icons.abc_outlined,
    required this.textController
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: widget.verticalMargin, horizontal: 15),
        child: TextField(
          controller: widget.textController,
          obscureText: widget.isObscure,
          decoration: InputDecoration(
              prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
              suffixIcon: widget.hasSuffixIcon ? IconButton(
                  icon: widget.isObscure ? Icon(widget.suffixIcon)  : Icon(widget.pressedSuffixIcon),
                  color: Colors.grey,
                onPressed: () {
                  setState(() {
                    widget.isObscure = !widget.isObscure;
                  });
                },
              ) : null,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ),
              hintText: widget.hintText,
              labelText: widget.labelText,
              errorText: widget.textController.text.isEmpty ? null : widget.errorText,
              labelStyle: const TextStyle(color: Colors.grey)
          ),
        )
    );
  }
}