import 'package:flutter/material.dart';
import '../model/financial_data_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getTransactionColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_getTransactionIcon(), color: _getTransactionColor()),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          transaction.time,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '₹${transaction.amount}',
          style: TextStyle(
            color: transaction.type == 'income' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon() {
    switch (transaction.title.toLowerCase()) {
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'subscription':
        return Icons.subscriptions_outlined;
      case 'travel':
        return Icons.travel_explore;
      case 'food':
        return Icons.fastfood_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color _getTransactionColor() {
    switch (transaction.title.toLowerCase()) {
      case 'shopping':
        return Colors.orange;
      case 'subscription':
        return Colors.purple;
      case 'travel':
        return Colors.blue;
      case 'food':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
