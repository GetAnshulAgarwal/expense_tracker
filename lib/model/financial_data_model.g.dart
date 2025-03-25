// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel()
      ..title = fields[0] as String
      ..category = fields[1] as String
      ..amount = fields[2] as double
      ..time = fields[3] as String
      ..type = fields[4] as String
      ..description = fields[5] as String
      ..wallet = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.wallet);
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

class FinancialSummaryAdapter extends TypeAdapter<FinancialSummary> {
  @override
  final int typeId = 1;

  @override
  FinancialSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FinancialSummary()
      ..accountBalance = fields[0] as double
      ..totalIncome = fields[1] as double
      ..totalExpenses = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, FinancialSummary obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.accountBalance)
      ..writeByte(1)
      ..write(obj.totalIncome)
      ..writeByte(2)
      ..write(obj.totalExpenses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinancialSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
