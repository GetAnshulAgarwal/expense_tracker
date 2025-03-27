import 'package:flutter/material.dart';
import '../model/financial_data_model.dart';
import 'transaction_item.dart';

class AllTransactionsScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final void Function(dynamic) onDelete; // Pass the deletion callback

  const AllTransactionsScreen({
    Key? key,
    required this.transactions,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionItem(
            transaction: transactions[index],
            onDelete: onDelete, // Use the passed callback
          );
        },
      ),
    );
  }
}
