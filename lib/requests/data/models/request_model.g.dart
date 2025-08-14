// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestModelAdapter extends TypeAdapter<RequestModel> {
  @override
  final int typeId = 6;

  @override
  RequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RequestModel(
      id: fields[0] as String,
      type: fields[1] as RequestType,
      status: fields[2] as RequestStatus,
      student: fields[3] as StudentInfoModel,
      parent: fields[4] as ParentInfoModel,
      outTime: fields[5] as DateTime,
      returnTime: fields[6] as DateTime,
      reason: fields[7] as String,
      requestedAt: fields[8] as DateTime,
      timeline: (fields[9] as List).cast<TimelineEventModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RequestModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.student)
      ..writeByte(4)
      ..write(obj.parent)
      ..writeByte(5)
      ..write(obj.outTime)
      ..writeByte(6)
      ..write(obj.returnTime)
      ..writeByte(7)
      ..write(obj.reason)
      ..writeByte(8)
      ..write(obj.requestedAt)
      ..writeByte(9)
      ..write(obj.timeline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
