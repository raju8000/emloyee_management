import 'package:employee_management/model/ModelEmployee.dart';
import 'package:hive/hive.dart';
import 'employee_adapter.dart';

class EmployeeDatabase {
  static const _employeeBoxName = 'employeeBox';
  static Box<ModelEmployee>? _employeeBox;
  static ModelEmployee lastDeleted = ModelEmployee();

  static Future<void> initialize() async {
    Hive.registerAdapter(EmployeeAdapter());
    _employeeBox = await Hive.openBox<ModelEmployee>(_employeeBoxName);
  }

  static Future<void> addEmployee(ModelEmployee employee) async {
    await _employeeBox!.add(employee);
  }

  static Future<void> undoDelete(int index) async {
    List<ModelEmployee> temp = _employeeBox!.values.toList();
    temp.insert(index, lastDeleted);
    await _employeeBox!.clear();
    await _employeeBox!.addAll(temp);
  }

  static Future<void> updateEmployee(int index,ModelEmployee employee) async {
    await _employeeBox!.putAt(index, employee);
  }

  static Future<void> deleteEmployee(int index) async {
    lastDeleted = _employeeBox!.getAt(index)!;
    await _employeeBox!.deleteAt(index);
  }

  static List<ModelEmployee> getAllEmployees() {
    return _employeeBox!.values.toList();
  }
}