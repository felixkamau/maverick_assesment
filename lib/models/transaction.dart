// import 'package:currency_converter/currency.dart';
import 'package:hive/hive.dart';
part 'transaction.g.dart';
/*
  Our transaction model to be stored on hive
 */

// Todo add reference to  member id in the tx model

@HiveType(typeId: 1) // Out Type adapter
class TransactionModel {
  @HiveField(0)
  final String recipient;

  @HiveField(1)
  final DateTime dateTx;

  @HiveField(2)
  final double txAmount;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final bool isCredit;

  const TransactionModel({
    required this.recipient,
    required this.dateTx,
    required this.txAmount,
    required this.currency,
    required this.isCredit,
  });
}
