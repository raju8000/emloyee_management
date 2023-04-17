import 'package:employee_management/controller/employee_controller.dart';
import 'package:employee_management/model/ModelEmployee.dart';
import 'package:employee_management/resources/string_constant.dart';
import 'package:employee_management/view/screen_employee_modification.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

class EmployeeCard extends ConsumerWidget {
  const EmployeeCard({Key? key, required this.employee, required this.index, this.isCurrentEmployee = true}) : super(key: key);
  final ModelEmployee employee;
  final int index;
  final bool isCurrentEmployee;


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var employeeNotifier = ref.read(employeeProvider);
    String date = employee.toDate!.isEmpty? "From ${employee.fromDate!}" : "${employee.fromDate!} - ${employee.toDate!}";
    final  snackBar =   SnackBar(
      content: const Text(Strings.employeeDeleted),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          employeeNotifier.undoDelete(index);
        },
      ),
    );
     double height = 0.9.h;
    return Slidable(
      key: ValueKey(index),
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        extentRatio: 0.25,
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (context) {
              ScaffoldMessenger.of(context).clearSnackBars();
              employeeNotifier.deleteEmployee(index,isCurrentEmployee);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: InkWell(
        onTap:(){
          employee.index = employeeNotifier.findDatabaseIndexOf(index, isCurrentEmployee);
          Navigator.of(context).pushNamed(ScreenEmployeeModification.routeName,arguments: employee);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 1.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(employee.employeeName!,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600,)),
                   SizedBox(height: height,),
                  Text(employee.employeeRole!,style: const TextStyle(fontSize: 12,color: Color(0xff949C9E))),
                   SizedBox(height: height,),
                  Text(date,style: const TextStyle(fontSize: 11,color: Color(0xff949C9E))),
                ],
              ),
            ),
              const Divider(thickness: 0.5,height: 2,)
          ],
        ),
      ),
    );
  }
}