import 'package:employee_management/controller/employee_controller.dart';
import 'package:employee_management/resources/colors_properties.dart';
import 'package:employee_management/resources/string_constant.dart';
import 'package:employee_management/view/screen_employee_modification.dart';
import 'package:employee_management/view/widgets/employee_card.dart';
import 'package:employee_management/view/widgets/rounded_corner_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class ScreenEmployees extends ConsumerWidget {
  static const String routeName = "employeeList";
  const ScreenEmployees({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.employeeList),centerTitle: false,),
      body: Consumer(
        builder: (context, ref,_) {
          var employeeNotifier = ref.watch(employeeProvider);
          return employeeNotifier.employeeList.isNotEmpty?
            Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ///Current Employee
                      if(employeeNotifier.currentEmployee.isNotEmpty)
                        Container(
                          color: Gray,
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(18),
                            child: const Text(Strings.currentEmployees,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: PrimaryBlue))
                        ),

                      if(employeeNotifier.currentEmployee.isNotEmpty)
                      ListView.builder(
                        itemCount: employeeNotifier.currentEmployee.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return EmployeeCard(
                                employee: employeeNotifier.currentEmployee[index],
                                index :index
                            );
                          }
                      ),

                      ///Previous Employee
                      if(employeeNotifier.previousEmployee.isNotEmpty)
                        Container(
                            color: Gray,
                            width: double.maxFinite,
                            padding: const EdgeInsets.all(20),
                            child: const Text(Strings.previousEmployees,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: PrimaryBlue))
                        ),

                      if(employeeNotifier.previousEmployee.isNotEmpty)
                      ListView.builder(
                          itemCount: employeeNotifier.previousEmployee.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return EmployeeCard(
                                employee: employeeNotifier.previousEmployee[index],
                                index :index,isCurrentEmployee: false,
                            );
                          }
                      ),

                      SizedBox(height: 10.h+MediaQuery.of(context).padding.bottom,)
                    ],
                  ),
                ),
                SizedBox(
                  height: double.maxFinite,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 10.h+MediaQuery.of(context).padding.bottom,
                        color: Gray,
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(20),
                        child: const Text(Strings.swipeLeftToDelete)),
                  ),
                )
              ],
            )
           :
              ///No Data for employees
           Center(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w ),
              child: Image.asset("assets/no_data.png"),
            ),
          );
        }
      ),
      floatingActionButton: RoundedCornerButton(
        width: 48,
        verticalPadding: 0.3.h,
        onPressed: (){
          Navigator.of(context).pushNamed(ScreenEmployeeModification.routeName);
        },
        child: const Icon(Icons.add, color: Colors.white,)
        //Text("+", style: TextStyle(color: Colors.white, fontSize: 20.sp),textAlign: TextAlign.center,),
      )
    );
  }
}

