import 'package:flutter/material.dart';

class Txtfield extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final VoidCallback onTap;
  final bool isReadOnly;
  const Txtfield({
    Key? key,
    required this.controller,
    required this.label,
    required this.onTap,
    this.isReadOnly = false,
  }) : super(key: key);

  @override
  State<Txtfield> createState() => _TxtfieldState();
}

class _TxtfieldState extends State<Txtfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // ignore: avoid_bool_literals_in_conditional_expressions
      readOnly: widget.isReadOnly,
      onTap: widget.onTap,
      controller: widget.controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        fillColor: Colors.white,
      ),
    );
  }
}
