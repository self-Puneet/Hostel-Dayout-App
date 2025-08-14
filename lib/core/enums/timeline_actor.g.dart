// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_actor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimelineActorAdapter extends TypeAdapter<TimelineActor> {
  @override
  final int typeId = 2;

  @override
  TimelineActor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimelineActor.student;
      case 1:
        return TimelineActor.parent;
      case 2:
        return TimelineActor.warden;
      case 3:
        return TimelineActor.security;
      case 4:
        return TimelineActor.server;
      default:
        return TimelineActor.student;
    }
  }

  @override
  void write(BinaryWriter writer, TimelineActor obj) {
    switch (obj) {
      case TimelineActor.student:
        writer.writeByte(0);
        break;
      case TimelineActor.parent:
        writer.writeByte(1);
        break;
      case TimelineActor.warden:
        writer.writeByte(2);
        break;
      case TimelineActor.security:
        writer.writeByte(3);
        break;
      case TimelineActor.server:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineActorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
