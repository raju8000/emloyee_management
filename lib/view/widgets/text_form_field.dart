import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SimpleTextFormField extends StatelessWidget {
  const SimpleTextFormField({
    Key? key,
    @required TextEditingController? textController,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode
  }) : _textController = textController,
        super(key: key);

  final TextEditingController? _textController;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      autocorrect: false,
      style: TextStyle(fontSize: 10.sp),
      focusNode: focusNode,
      decoration:  InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xffE5E5E5)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xffE5E5E5)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.symmetric(vertical: 1)
      ),
    );
  }
}