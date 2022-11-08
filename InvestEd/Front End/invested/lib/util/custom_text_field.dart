import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  // Setting base properties
  final String hintText;
  final String labelText;
  final bool hasSuffixIcon;
  final bool isObscure;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final IconData pressedSuffixIcon;
  final TextEditingController textController;

  const CustomTextField({
        Key? key,
    this.hintText = '',
    this.labelText = '',
    this.hasSuffixIcon = false,
    this.isObscure = false,
    this.prefixIcon = Icons.abc_outlined,
    this.suffixIcon = Icons.abc_outlined,
    this.pressedSuffixIcon = Icons.abc_outlined,
    required this.textController
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: TextField(
          controller: widget.textController,
          obscureText: !isVisible,
          decoration: InputDecoration(
              prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
              suffixIcon: widget.hasSuffixIcon ? IconButton(
                  icon: isVisible ? Icon(widget.pressedSuffixIcon) : Icon(widget.suffixIcon),
                  color: Colors.grey,
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
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
              labelStyle: const TextStyle(color: Colors.grey)
          ),
        )
    );
  }
}