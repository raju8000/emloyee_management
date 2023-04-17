import 'dart:math';


import 'package:employee_management/calendar_date_picker/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

Future<List<DateTime?>?> showCalendarDatePicker2Dialog({
  required BuildContext context,
  required CalendarDatePicker2WithActionButtonsConfig config,
  required Size dialogSize,
  List<DateTime?> value = const [],
  BorderRadius? borderRadius,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  bool isFromDate = true,
  Color? dialogBackgroundColor,
  RouteSettings? routeSettings,
  String? barrierLabel,
  TransitionBuilder? builder,
}) {
  var dialog = AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    contentPadding: EdgeInsets.zero,
    backgroundColor: dialogBackgroundColor ?? Theme.of(context).canvasColor,
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    content: SizedBox(
      width: dialogSize.width,
      height: max(dialogSize.height, 300),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalendarDatePicker2WithActionButtons(
            value: value,
            isFromDate:isFromDate,
            config: config.copyWith(openedFromDialog: true),
          ),
        ],
      ),
    ),
  );

  return showDialog<List<DateTime?>>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
  );
}
