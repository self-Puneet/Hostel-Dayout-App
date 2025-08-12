// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestTypeAdapter extends TypeAdapter<RequestType> {
  @override
  final int typeId = 1;

  @override
  RequestType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RequestType.dayout;
      case 1:
        return RequestType.leave;
      default:
        return RequestType.dayout;
    }
  }

  @override
  void write(BinaryWriter writer, RequestType obj) {
    switch (obj) {
      case RequestType.dayout:
        writer.writeByte(0);
        break;
      case RequestType.leave:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
