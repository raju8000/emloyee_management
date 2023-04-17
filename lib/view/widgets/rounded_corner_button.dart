import 'package:employee_management/resources/colors_properties.dart';
import 'package:flutter/material.dart';

class RoundedCornerButton extends StatelessWidget {
  const RoundedCornerButton({
    Key? key,
    this.backgroundColour = PrimaryBlue,
    required this.onPressed,
    this.child,this.borderColour,
    this.width,
    this.cornerRadius =8,
    this.text,
    this.verticalPadding,
    this.textColor,
    this.fontSize
  }) : super(key: key);

  final Color? backgroundColour;
  final Color? borderColour;
  final VoidCallback onPressed;
  final double? width;
  final Widget? child;
  final double? cornerRadius;
  final double? verticalPadding;
  final String? text;
  final Color? textColor;
  final double? fontSize;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width??double.maxFinite,
      child: TextButton(
          onPressed: onPressed,
          style: backgroundColour!=null? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(backgroundColour!),
              overlayColor: MaterialStateProperty.all<Color>(backgroundColour!),
              shape: cornerRadius!=null? MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(cornerRadius!),
                      side: BorderSide(color: backgroundColour!)
                  )
              ): null
          ): null,

          child: Padding(
            padding: EdgeInsets.symmetric(vertical:verticalPadding??0.0),
            child: child??Text(text??"", style: TextStyle(color: textColor??Colors.white, fontSize: fontSize),textAlign: TextAlign.center,),
          )
      ),
    );
  }
}