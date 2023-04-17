import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ModelEmployee {
  ModelEmployee({
      this.employeeName, 
      this.employeeRole, 
      this.fromDate, 
      this.toDate,});

  ModelEmployee.fromJson(dynamic json) {
    id = json['id'];
    employeeName = json['employee_name'];
    employeeRole = json['employee_role'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
  }
  @HiveField(0)
  int id =0 ;
  @HiveField(1)
  String? employeeName;
  @HiveField(2)
  String? employeeRole;
  @HiveField(3)
  String? fromDate;
  @HiveField(4)
  String? toDate;

  int? index;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['employee_name'] = employeeName;
    map['employee_role'] = employeeRole;
    map['from_date'] = fromDate;
    map['to_date'] = toDate;
    return map;
  }

}