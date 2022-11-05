import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  // Setting base properties
  final String hintText;
  final String labelText;
  final IconData icon;
  final TextEditingController textController;

  const CustomTextField({
        Key? key,
    this.hintText = '',
    this.labelText = '',
    this.icon = Icons.abc_outlined,
    required this.textController
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: TextField(
          controller: widget.textController,
          decoration: InputDecoration(
              prefixIcon: Icon(widget.icon, color: Colors.grey),
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