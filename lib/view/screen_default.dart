import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScreenDefault extends StatelessWidget {
  const ScreenDefault({Key? key}) : super(key: key);
  static const routeName = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Screen Not found",style: TextStyle(fontSize: 15.sp),),
    );
  }
}
