import 'package:hive/hive.dart';

part 'financial_data_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String category;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String time;

  @HiveField(4)
  late String type; // "income" or "expense"

  @HiveField(5)
  late String description;

  @HiveField(6)
  late String wallet;

  @HiveField(7)
  late String userId; // New field to tag the transaction with the user's UID
}

@HiveType(typeId: 1)
class FinancialSummary extends HiveObject {
  @HiveField(0)
  late double accountBalance;

  @HiveField(1)
  late double totalIncome;

  @HiveField(2)
  late double totalExpenses;
}
