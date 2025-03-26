import 'package:flutter/material.dart';
import '../model/financial_data_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Icon with light background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getTransactionColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getTransactionIcon(), color: _getTransactionColor()),
          ),
          const SizedBox(width: 12),

          // Title & Description on the left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (e.g. Shopping)
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                // Description (if any)
                if (transaction.description.isNotEmpty)
                  Text(
                    transaction.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),

          // Amount & Time on the right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount with a minus sign for expense
              Text(
                _formatAmount(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      transaction.type == 'income' ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              // Time
              Text(
                transaction.time,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount() {
    if (transaction.type == 'expense') {
      return '-₹${transaction.amount}';
    } else {
      return '₹${transaction.amount}';
    }
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
