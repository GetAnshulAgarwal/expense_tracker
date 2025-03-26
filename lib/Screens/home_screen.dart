import 'package:assignment_cs/transactions/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../color.dart';
import '../model/financial_data_model.dart';
import '../widgets/bottom_navigation.dart';
import '../transactions/transaction_item.dart';
import 'expense_screen.dart';
import 'income_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  final User user; // required user

  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double accountBalance;
  late double income;
  late double expenses;
  List<TransactionModel> recentTransactions = [];
  final Box<FinancialSummary> summaryBox = Hive.box<FinancialSummary>(
    'summaryBox',
  );
  final Box<TransactionModel> transactionsBox = Hive.box<TransactionModel>(
    'transactionsBox',
  );

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  // Load financial data specific to the logged-in user
  void _loadFinancialData() {
    final existingSummary = summaryBox.get(
      '${widget.user.uid}_financialSummary',
    );

    setState(() {
      accountBalance = existingSummary?.accountBalance ?? 38000;
      income = existingSummary?.totalIncome ?? 50000;
      expenses = existingSummary?.totalExpenses ?? 12000;
      // Load all transactions for the user
      recentTransactions =
          transactionsBox.values
              .where((transaction) => transaction.userId == widget.user.uid)
              .toList()
              .reversed
              .toList();
    });
  }

  // Update the financials for the current user only
  void _updateFinancials(Map<String, dynamic>? newTransaction, bool isIncome) {
    if (newTransaction != null) {
      final transaction =
          TransactionModel()
            ..title = newTransaction['category']
            ..category = newTransaction['description'] ?? ''
            ..amount = newTransaction['amount']
            ..time = DateTime.now().toString().substring(11, 16)
            ..type = isIncome ? 'income' : 'expense'
            ..description = newTransaction['description'] ?? ''
            ..wallet = newTransaction['wallet'] ?? ''
            ..userId = widget.user.uid; // tag with the current user id

      transactionsBox.add(transaction);

      setState(() {
        if (isIncome) {
          income += transaction.amount;
          accountBalance += transaction.amount;
        } else {
          expenses += transaction.amount;
          accountBalance -= transaction.amount;
        }

        // Insert new transaction at the beginning
        recentTransactions.insert(0, transaction);

        final summary =
            FinancialSummary()
              ..accountBalance = accountBalance
              ..totalIncome = income
              ..totalExpenses = expenses;

        summaryBox.put('${widget.user.uid}_financialSummary', summary);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildTopBar(),
                const SizedBox(height: 20),
                _buildBalanceSection(),
                const SizedBox(height: 20),
                _buildIncomeExpenseSection(),
                const SizedBox(height: 20),
                _buildRecentTransactionsHeader(),
                const SizedBox(height: 10),
                _buildRecentTransactions(), // Scrollable list now in a fixed-height container
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(user: widget.user),
              ),
            );
          }
          // Add additional logic for other indexes if needed.
          print('Tapped index: $index');
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'October',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.notifications_none_rounded,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Balance',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '₹$accountBalance',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseSection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IncomeScreen()),
              );
              _updateFinancials(result, true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Income',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹$income',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpenseScreen()),
              );
              _updateFinancials(result, false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF44336),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expenses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹$expenses',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_upward, color: Colors.white, size: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        // Wrap "See All" text in a GestureDetector to navigate to the AllTransactionsScreen
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        AllTransactionsScreen(transactions: recentTransactions),
              ),
            );
          },
          child: Text(
            'See All',
            style: TextStyle(
              color: Colors.purple[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Now, display all transactions in a scrollable list inside a fixed-height container.
  Widget _buildRecentTransactions() {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: recentTransactions.length,
        itemBuilder: (context, index) {
          return TransactionItem(transaction: recentTransactions[index]);
        },
      ),
    );
  }
}
