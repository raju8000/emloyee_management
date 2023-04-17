import 'package:employee_management/calendar_date_picker/calendar_date_picker2.dart';
import 'package:employee_management/resources/colors_properties.dart';
import 'package:employee_management/resources/string_constant.dart';
import 'package:employee_management/view/widgets/rounded_corner_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CalendarDatePicker2WithActionButtons extends StatefulWidget {
  const CalendarDatePicker2WithActionButtons({
    required this.value,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    this.onCancelTapped,
    this.onOkTapped,
    required this.isFromDate,
    Key? key,
  }) : super(key: key);

  final List<DateTime?> value;

  /// Called when the user taps 'OK' button
  final ValueChanged<List<DateTime?>>? onValueChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The calendar configurations including action buttons
  final CalendarDatePicker2WithActionButtonsConfig config;

  /// The callback when cancel button is tapped
  final Function? onCancelTapped;

  /// The callback when ok button is tapped
  final Function? onOkTapped;

  final bool isFromDate;

  @override
  State<CalendarDatePicker2WithActionButtons> createState() =>
      _CalendarDatePicker2WithActionButtonsState();
}

class _CalendarDatePicker2WithActionButtonsState
    extends State<CalendarDatePicker2WithActionButtons> {
  List<DateTime?> _values = [];
  List<DateTime?> _editCache = [];
  late ValueNotifier<String> selectedDateLabel;

  @override
  void initState() {
    _values = widget.value;
    _editCache = widget.value;
    if(_values.isNotEmpty && _values.first!=null){
      selectedDateLabel = ValueNotifier(DateFormat(Strings.dateFormat).format(_values.first!));
    }
    else {
      selectedDateLabel = ValueNotifier(widget.isFromDate? DateFormat(Strings.dateFormat).format(DateTime.now()): Strings.noDate);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(
      covariant CalendarDatePicker2WithActionButtons oldWidget) {
    var isValueSame = oldWidget.value.length == widget.value.length;

    if (isValueSame) {
      for (var i = 0; i < oldWidget.value.length; i++) {
        var isSame = (oldWidget.value[i] == null && widget.value[i] == null) ||
            DateUtils.isSameDay(oldWidget.value[i], widget.value[i]);
        if (!isSame) {
          isValueSame = false;
          break;
        }
      }
    }

    if (!isValueSame) {
      _values = widget.value;
      _editCache = widget.value;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 7,),
        MediaQuery.removePadding(
          context: context,
          child: CalendarDatePicker2(
            value: [..._editCache],
            config: widget.config,
            isFromDate:widget.isFromDate,
            onDateSelect: (_){
              if(!widget.isFromDate){
                selectedDateLabel.value = Strings.noDate;
              }
            },
            onValueChanged: (values){
              _editCache = values;
              selectedDateLabel.value =  DateFormat(Strings.dateFormat).format(values[0]??DateTime.now());
            },
            onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
          ),
        ),
        SizedBox(height: widget.config.gapBetweenCalendarAndButtons ?? 10),
        const Divider(),
        Row(
          children: [
            SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
            Row(
              children: [
                SizedBox(width: 20,child: Image.asset("assets/ic_calendar.png")),
                const SizedBox(width: 8,),
                ValueListenableBuilder(
                    valueListenable: selectedDateLabel,
                    builder: (BuildContext context, String counterValue, child){
                      return  Text(counterValue,style: TextStyle(fontSize: 10.sp),);
                    }
                )

              ],
            ),
            const Spacer(),
            _buildCancelButton(Theme.of(context).colorScheme, localizations),

            SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
            _buildOkButton(Theme.of(context).colorScheme, localizations),
            SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
          ],
        ),
      ],
    );
  }

  Widget _buildCancelButton(
      ColorScheme colorScheme, MaterialLocalizations localizations) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _editCache = _values;
        widget.onCancelTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnCancelTapped ?? true)) {

          Navigator.pop(context);
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child:RoundedCornerButton(
          backgroundColour: LightBlue,
          width: 80,
          text: Strings.cancel,
          textColor:PrimaryBlue,
          verticalPadding: 4,fontSize: 10.sp,
          onPressed: () {
            if ((widget.config.openedFromDialog ?? false) &&
                (widget.config.closeDialogOnCancelTapped ?? true)) {

              Navigator.pop(context);
            }
          },
        ),
        /*widget.config.cancelButton ??
            Text(
              localizations.cancelButtonLabel.toUpperCase(),
              style: widget.config.cancelButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ??
                        colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),*/
      ),
    );
  }

  Widget _buildOkButton(
      ColorScheme colorScheme, MaterialLocalizations localizations) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: (){} /*=> setState(() {
        _values = _editCache;
        widget.onValueChanged?.call(_values);
        widget.onOkTapped?.call();
        if ((widget.config.openedFromDialog ?? false) &&
            (widget.config.closeDialogOnOkTapped ?? true)) {
          Navigator.pop(context, _values);
        }
      })*/,
      child: Container(
        padding: widget.config.buttonPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: RoundedCornerButton(
          backgroundColour: PrimaryBlue,
          width: 80,
          verticalPadding: 4,fontSize: 10.sp,
          text: Strings.save,
          onPressed: () => setState(() {
            _values = _editCache;
            widget.onValueChanged?.call(_values);
            widget.onOkTapped?.call();
            if ((widget.config.openedFromDialog ?? false) &&
                (widget.config.closeDialogOnOkTapped ?? true)) {
              if(selectedDateLabel.value == Strings.noDate){
                Navigator.pop(context);
              }
              else {
                Navigator.pop(context, _values);
              }
            }
          })
        ),
        /*widget.config.okButton ??
            Text(
              localizations.okButtonLabel.toUpperCase(),
              style: widget.config.okButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ??
                        colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),*/
      ),
    );
  }
}
