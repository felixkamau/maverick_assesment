// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 1;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      recipient: fields[0] as String,
      dateTx: fields[1] as DateTime,
      txAmount: fields[2] as double,
      currency: fields[3] as String,
      isCredit: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.recipient)
      ..writeByte(1)
      ..write(obj.dateTx)
      ..writeByte(2)
      ..write(obj.txAmount)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.isCredit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
