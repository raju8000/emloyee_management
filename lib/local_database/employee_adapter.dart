import 'package:employee_management/model/ModelEmployee.dart';
import 'package:hive/hive.dart';

class EmployeeAdapter extends TypeAdapter<ModelEmployee> {
  @override
  final int typeId = 0;

  @override
  ModelEmployee read(BinaryReader reader) {
    final id = reader.readInt();
    final name = reader.readString();
    final role = reader.readString();
    final fromDate = reader.readString();
    final toDate = reader.readBool() ?reader.readString():null;
    return ModelEmployee(
      employeeName: name,
      employeeRole: role,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  void write(BinaryWriter writer, ModelEmployee obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.employeeName!);
    writer.writeString(obj.employeeRole!);
    writer.writeString(obj.fromDate!);
    writer.writeBool(obj.toDate != null);
    if (obj.toDate != null) {
      writer.writeString(obj.toDate!);
    }
  }
}