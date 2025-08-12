// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestStateAdapter extends TypeAdapter<RequestState> {
  @override
  final int typeId = 8;

  @override
  RequestState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RequestState.active;
      case 1:
        return RequestState.inactive;
      default:
        return RequestState.active;
    }
  }

  @override
  void write(BinaryWriter writer, RequestState obj) {
    switch (obj) {
      case RequestState.active:
        writer.writeByte(0);
        break;
      case RequestState.inactive:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
