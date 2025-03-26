import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/financial_data_model.dart';
import 'transaction_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Box<TransactionModel> transactionsBox;
  List<TransactionModel> allTransactions = [];

  @override
  void initState() {
    super.initState();
    transactionsBox = Hive.box<TransactionModel>('transactionsBox');
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      // Sort transactions by time, most recent first
      allTransactions =
          transactionsBox.values.toList()..sort(
            (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: allTransactions.length,
        itemBuilder: (context, index) {
          return TransactionItem(transaction: allTransactions[index]);
        },
      ),
    );
  }
}
