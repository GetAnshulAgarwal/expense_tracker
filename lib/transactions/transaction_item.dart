import 'package:flutter/material.dart';
import '../model/financial_data_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final void Function(dynamic) onDelete; // Callback function for deletion

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.key.toString()), // Use Hive's key instead of id
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete(transaction.key); // Pass key to deletion callback
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTransactionColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getTransactionIcon(), color: _getTransactionColor()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (transaction.description.isNotEmpty)
                    Text(
                      transaction.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        transaction.type == 'income'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount() {
    return transaction.type == 'expense'
        ? '-₹${transaction.amount}'
        : '₹${transaction.amount}';
  }

  IconData _getTransactionIcon() {
    switch (transaction.title.toLowerCase()) {
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'subscription':
        return Icons.subscriptions_outlined;
      case 'travel':
        return Icons.directions_car_filled;
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
