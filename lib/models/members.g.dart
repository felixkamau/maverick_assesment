// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberModelAdapter extends TypeAdapter<MemberModel> {
  @override
  final int typeId = 2;

  @override
  MemberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberModel(
      id: fields[0] as String,
      groupId: fields[1] as String,
      name: fields[2] as String,
      phoneNumber: fields[3] as String,
      groupName: fields[4] as String,
      totalContributions: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MemberModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.groupId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.groupName)
      ..writeByte(5)
      ..write(obj.totalContributions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
