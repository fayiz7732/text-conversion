import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextFiled extends StatefulWidget {
  const CommonTextFiled({
    super.key,
    this.hintText,
    this.controller,
  });
  final String? hintText;
  final TextEditingController? controller;

  @override
  State<CommonTextFiled> createState() => _CommonTextFiledState();
}

class _CommonTextFiledState extends State<CommonTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: Color(int.parse('0xFFDFDEEE')),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: Color(int.parse('0xFFDFDEEE')),
          ),
        ),
        filled: true,
        fillColor: Color(int.parse('0xFFDFDEEE')),
        hintText: widget.hintText ?? '',
      ),
    );
  }
}
