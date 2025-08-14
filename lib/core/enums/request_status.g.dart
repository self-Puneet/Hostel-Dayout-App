// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RequestStatusAdapter extends TypeAdapter<RequestStatus> {
  @override
  final int typeId = 0;

  @override
  RequestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RequestStatus.requested;
      case 1:
        return RequestStatus.referred;
      case 2:
        return RequestStatus.cancelled;
      case 3:
        return RequestStatus.parentApproved;
      case 4:
        return RequestStatus.parentDenied;
      case 5:
        return RequestStatus.rejected;
      case 6:
        return RequestStatus.approved;
      case 7:
        return RequestStatus.inactive;
      default:
        return RequestStatus.requested;
    }
  }

  @override
  void write(BinaryWriter writer, RequestStatus obj) {
    switch (obj) {
      case RequestStatus.requested:
        writer.writeByte(0);
        break;
      case RequestStatus.referred:
        writer.writeByte(1);
        break;
      case RequestStatus.cancelled:
        writer.writeByte(2);
        break;
      case RequestStatus.parentApproved:
        writer.writeByte(3);
        break;
      case RequestStatus.parentDenied:
        writer.writeByte(4);
        break;
      case RequestStatus.rejected:
        writer.writeByte(5);
        break;
      case RequestStatus.approved:
        writer.writeByte(6);
        break;
      case RequestStatus.inactive:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
