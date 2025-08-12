// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentInfoModelAdapter extends TypeAdapter<StudentInfoModel> {
  @override
  final int typeId = 4;

  @override
  StudentInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentInfoModel(
      name: fields[0] as String,
      enrollment: fields[1] as String,
      room: fields[2] as String,
      year: fields[3] as String,
      block: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentInfoModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.enrollment)
      ..writeByte(2)
      ..write(obj.room)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.block);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
