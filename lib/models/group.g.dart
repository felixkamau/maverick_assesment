// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupModelAdapter extends TypeAdapter<GroupModel> {
  @override
  final int typeId = 0;

  @override
  GroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupModel(
      id: fields[0] as String,
      groupType: fields[6] as String,
      contributionAmount: fields[7] as double,
      contributionFrequency: fields[8] as String,
      meetingFrequency: fields[9] as String,
      name: fields[1] as String,
      numberOfMembers: fields[2] as int,
      treasurer: fields[3] as String,
      createdAt: fields[4] as DateTime,
      description: fields[5] as String,
      groupBal: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, GroupModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.numberOfMembers)
      ..writeByte(3)
      ..write(obj.treasurer)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.groupType)
      ..writeByte(7)
      ..write(obj.contributionAmount)
      ..writeByte(8)
      ..write(obj.contributionFrequency)
      ..writeByte(9)
      ..write(obj.meetingFrequency)
      ..writeByte(10)
      ..write(obj.groupBal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
