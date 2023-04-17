import 'package:employee_management/local_database/employee_helper.dart';
import 'package:employee_management/model/ModelEmployee.dart';
import 'package:employee_management/resources/string_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final employeeProvider = ChangeNotifierProvider.autoDispose<EmployeeNotifier>((ref) {
return EmployeeNotifier();
});

class EmployeeNotifier extends ChangeNotifier{

  EmployeeNotifier(){
    getAllEmployeeList();
  }
  List<ModelEmployee> employeeList = [];
  List<ModelEmployee> currentEmployee = [];
  List<ModelEmployee> previousEmployee = [];
  int lastDeletedIndex = -1;

  Future<void> addEmployee(String name,String role,String fromDate, String toDate) async {
    ModelEmployee employee = ModelEmployee(employeeName: name,employeeRole: role,fromDate: fromDate,toDate: toDate);
    await EmployeeDatabase.addEmployee(employee);
    getAllEmployeeList();
  }

  Future<void> updateEmployee(String name,String role,String fromDate, String toDate, int index) async {
    ModelEmployee employee = ModelEmployee(employeeName: name,employeeRole: role,fromDate: fromDate,toDate: toDate);
    await EmployeeDatabase.updateEmployee(index,employee);
    getAllEmployeeList();
  }

  Future<void> deleteEmployee(int index, bool isCurrentEmployee) async {
    lastDeletedIndex = findDatabaseIndexOf(index,isCurrentEmployee);
    await EmployeeDatabase.deleteEmployee(lastDeletedIndex);
    getAllEmployeeList();
  }

  int findDatabaseIndexOf(int index, bool isCurrentEmployee){
    if(isCurrentEmployee) {
      return employeeList.indexOf(currentEmployee[index]);
    }else{
      return employeeList.indexOf(previousEmployee[index]);
    }
  }

  Future<void> undoDelete(int index) async {
    await EmployeeDatabase.undoDelete(lastDeletedIndex);
    getAllEmployeeList();
  }

  getAllEmployeeList(){
    employeeList = EmployeeDatabase.getAllEmployees();
    currentEmployee = [];
    previousEmployee = [];
    for(var employee in employeeList){
      if(isCurrentEmployee(employee)){
        currentEmployee.add(employee);
      }else{
        previousEmployee.add(employee);
      }
    }
    notifyListeners();
  }

  bool isCurrentEmployee(ModelEmployee employee){
    if(employee.toDate?.isNotEmpty?? false){
      DateTime now = DateTime.now();
      DateTime toDate = DateFormat(Strings.dateFormat).parse(employee.toDate!);
      int difference = DateTime(toDate.year, toDate.month, toDate.day).difference(DateTime(now.year, now.month, now.day)).inDays;
      if(difference >= 0){
        return true;
      }else{
        return false;
      }
    }
    else{
      return true;
    }
  }
}