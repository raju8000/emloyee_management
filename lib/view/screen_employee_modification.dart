
import 'package:employee_management/calendar_date_picker/calendar_date_picker2.dart';
import 'package:employee_management/controller/employee_controller.dart';
import 'package:employee_management/model/ModelEmployee.dart';
import 'package:employee_management/resources/colors_properties.dart';
import 'package:employee_management/resources/string_constant.dart';
import 'package:employee_management/view/widgets/rounded_corner_button.dart';
import 'package:employee_management/view/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';



class ScreenEmployeeModification extends StatefulWidget {
  static const routeName = "/employeeModification";
  const ScreenEmployeeModification({Key? key, this.employee}) : super(key: key);
  final ModelEmployee? employee;

  @override
  State<ScreenEmployeeModification> createState() => _ScreenEmployeeModificationState();
}

class _ScreenEmployeeModificationState extends State<ScreenEmployeeModification> {
  final _employeeNameController = TextEditingController();
  final _employeeRoleController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    _fromDateController.text = Strings.today;
    if(widget.employee!=null){
      _employeeNameController.text = widget.employee!.employeeName!;
      _employeeRoleController.text = widget.employee!.employeeRole!;
      _fromDateController.text = widget.employee!.fromDate!;
      _toDateController.text = widget.employee!.toDate!;
    }
    super.initState();
  }
  @override
  void dispose() {
    _employeeNameController.dispose();
    _employeeRoleController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        appBar: AppBar(
          title: const Text(Strings.addEmployeeDetail),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),

        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: ()=> checkFocus(),
            child: Column(
              children: [
                ///Employee form
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      SizedBox(height: 2.h,),
                      SimpleTextFormField(
                        focusNode: focusNode,
                        textController: _employeeNameController,
                        prefixIcon: Image.asset("assets/ic_user.png"),
                        hintText: Strings.employeeName,
                      ),

                      SizedBox(height: 2.h,),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async => _employeeRoleController.text = await showRoleSheet()??_employeeRoleController.text,
                        child: IgnorePointer(
                          child: SimpleTextFormField(
                            textController: _employeeRoleController,
                            prefixIcon: Image.asset("assets/ic_role.png"),
                            hintText: Strings.selectRole,
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp,color: PrimaryBlue,),
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h,),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: ()=> showDatePicker(Strings.fromDate),
                              child: IgnorePointer(
                                child: SimpleTextFormField(
                                  textController: _fromDateController,
                                  prefixIcon: Image.asset("assets/ic_calendar2.png"),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8,),
                          const Icon(Icons.arrow_forward,color: PrimaryBlue,),
                          const SizedBox(width: 8,),

                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: ()=> showDatePicker(Strings.toDate),
                              child: IgnorePointer(
                                child: SimpleTextFormField(
                                  textController: _toDateController,
                                  prefixIcon: Image.asset("assets/ic_calendar2.png"),
                                  hintText: Strings.noDate,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                const Divider(thickness: 1.5,),

                ///Submit/Cancel button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedCornerButton(
                         text: Strings.cancel,
                          textColor: PrimaryBlue,
                          backgroundColour: LightBlue,
                          width: 80,verticalPadding: 0.4.h,
                          onPressed: (){
                           Navigator.of(context).pop();
                          }
                      ),
                      const SizedBox(width: 20,),
                      Consumer(
                          builder: (context, ref,_) {
                            var employeeNotifier = ref.read(employeeProvider);
                          return RoundedCornerButton(
                             text: Strings.save,
                              width: 17.w,verticalPadding: 0.4.h,
                              onPressed: () async {
                               if(_employeeNameController.text.trim().isNotEmpty && _employeeRoleController.text.trim().isNotEmpty){
                                 if(_fromDateController.text == Strings.today){
                                   _fromDateController.text = DateFormat(Strings.dateFormat).format(DateTime.now());
                                 }
                                 if(widget.employee == null) {
                                   employeeNotifier.addEmployee(_employeeNameController.text.trim(),
                                       _employeeRoleController.text.trim(),
                                     _fromDateController.text, _toDateController.text).then((_){
                                       Navigator.of(context).pop();
                                 });
                                 }else{
                                   employeeNotifier.updateEmployee(_employeeNameController.text.trim(),
                                       _employeeRoleController.text.trim(),
                                       _fromDateController.text, _toDateController.text,widget.employee!.index!).then((_){
                                     Navigator.of(context).pop();
                                   });
                                 }
                               }
                              }
                          );
                        }
                      ),
                      const SizedBox(width: 20,),
                    ],
                  ),
                ),
                    const SizedBox(height: 10,),
              ],
            ),
          ),
        )
    );
  }

  checkFocus(){
    if (focusNode.hasPrimaryFocus) {
      focusNode.unfocus();
    }
  }

  /// Date Picker
  showDatePicker(String type) async {
    checkFocus();
    DateTime? preSelectedDate;
    if(type == Strings.fromDate && _fromDateController.text.trim().isNotEmpty){
      preSelectedDate = _fromDateController.text==Strings.today? DateTime.now() : DateFormat(Strings.dateFormat).parse(_fromDateController.text);
    }
    if(type == Strings.toDate && _toDateController.text.trim().isNotEmpty){
      preSelectedDate = DateFormat(Strings.dateFormat).parse(_toDateController.text);
    }
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      isFromDate: type == Strings.fromDate,
      value: [preSelectedDate],
      config: CalendarDatePicker2WithActionButtonsConfig(
        centerAlignModePicker: true,
        firstDate: type != Strings.fromDate && _fromDateController.text!= Strings.today ? DateFormat(Strings.dateFormat).parse(_fromDateController.text):null,
        dayTextStyle: TextStyle(fontSize: 9.sp,fontWeight: FontWeight.w600),
        controlsTextStyle: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w700),
        weekdayLabels: ["Sun","Mon","Tue","Wed","Thu","Fri","Sat",],
        weekdayLabelTextStyle: TextStyle(fontSize: 10.sp)
      ),
      dialogSize: Size(100.w-30, type == Strings.fromDate?575:500),
      borderRadius: BorderRadius.circular(15),
    );

    if(results!=null && results.isNotEmpty){
      if(type == Strings.fromDate){
        _fromDateController.text = DateFormat(Strings.dateFormat).format(results.first!);
      }else{
        _toDateController.text = DateFormat(Strings.dateFormat).format(results.first!);
      }
    }
    else if(results==null && type != Strings.today){
      _toDateController.text = "";
    }
  }

  ///Employee Role selector
  Future<String?> showRoleSheet() async {
    checkFocus();
    List<String> roles = ["Product Designer","Flutter Developer","QA Tester","Product Owner"];
   return await showModalBottomSheet<String>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 230+MediaQuery.of(context).padding.bottom,
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
            )),
            child: ListView.separated(
              itemCount: roles.length,
                itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap:()=> Navigator.of(context).pop(roles[index]),
                      child: Center(child: Text(roles[index],style: TextStyle(fontSize: 11.sp),))
                  ),
                );
                }, separatorBuilder: (BuildContext context, int index) {
                return const Divider(thickness: 2,);
            },
            ),
          );
        });
  }
}


