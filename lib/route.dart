
import 'package:employee_management/model/ModelEmployee.dart';
import 'package:employee_management/view/screen_default.dart';
import 'package:employee_management/view/screen_employee_list.dart';
import 'package:employee_management/view/screen_employee_modification.dart';
import 'package:flutter/material.dart';

class RouteGenerator {

  static Route? generateRoute(RouteSettings settings) {
    // Getting arguments passed while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {

      case ScreenEmployees.routeName:  /// Employee Lists
        return MaterialPageRoute(
            settings: settings, builder: (_) => const ScreenEmployees());

      case ScreenEmployeeModification.routeName: /// Employee App/Update
        return MaterialPageRoute(
            settings: settings, builder: (_) => ScreenEmployeeModification(employee: args as ModelEmployee?,));

      default:
        MaterialPageRoute(
            settings: settings, builder: (_) => const ScreenDefault());
    }
    return null;
  }
}
