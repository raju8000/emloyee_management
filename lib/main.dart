import 'package:employee_management/local_database/employee_helper.dart';
import 'package:employee_management/route.dart';
import 'package:employee_management/view/screen_employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

 main() async {
   // Initialize hive
   await Hive.initFlutter();
   // Open the peopleBox
   await EmployeeDatabase.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Employee Management',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue,),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: ScreenEmployees.routeName,
        );
      }
    );
  }
}

