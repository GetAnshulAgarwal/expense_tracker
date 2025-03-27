import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/financial_data_model.dart';
import '../transactions/transaction_item.dart';
import '../transactions/transaction_screen.dart';
import '../widgets/bottom_navigation.dart';
import 'expense_screen.dart';
import 'income_screen.dart';
import 'profile_screen.dart';

enum DateRangeFilter { today, week, month, year }

class DashboardScreen extends StatefulWidget {
  final User user; // required user

  const DashboardScreen({super.key, required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double accountBalance;
  late double income;
  late double expenses;

  // Full list of user's transactions (unfiltered)
  List<TransactionModel> allUserTransactions = [];

  // The currently selected date range filter
  DateRangeFilter _selectedFilter = DateRangeFilter.today;

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

  /// Load financial data for the logged-in user.
  void _loadFinancialData() {
    final existingSummary = summaryBox.get(
      '${widget.user.uid}_financialSummary',
    );

    setState(() {
      accountBalance = existingSummary?.accountBalance ?? 0;
      income = existingSummary?.totalIncome ?? 0;
      expenses = existingSummary?.totalExpenses ?? 0;

      // Load ALL transactions (reverse order for most recent first)
      allUserTransactions =
          transactionsBox.values
              .where((transaction) => transaction.userId == widget.user.uid)
              .toList()
              .reversed
              .toList();
    });
  }

  /// Update the financials when a new transaction is added.
  void _updateFinancials(Map<String, dynamic>? newTransaction, bool isIncome) {
    if (newTransaction != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat.Hm().format(now); // e.g., "14:35"

      final transaction =
          TransactionModel()
            ..title = newTransaction['category']
            ..category = newTransaction['description'] ?? ''
            ..amount = newTransaction['amount']
            ..time =
                formattedTime // set the time string
            ..date =
                now // set the full DateTime
            ..type = isIncome ? 'income' : 'expense'
            ..description = newTransaction['description'] ?? ''
            ..wallet = newTransaction['wallet'] ?? ''
            ..userId = widget.user.uid;

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
        allUserTransactions.insert(0, transaction);

        final summary =
            FinancialSummary()
              ..accountBalance = accountBalance
              ..totalIncome = income
              ..totalExpenses = expenses;

        summaryBox.put('${widget.user.uid}_financialSummary', summary);
      });
    }
  }

  /// Returns transactions that fall within the selected date range.
  List<TransactionModel> get filteredTransactions {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedFilter) {
      case DateRangeFilter.today:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case DateRangeFilter.week:
        final weekday = now.weekday;
        startDate = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: weekday - 1));
        break;
      case DateRangeFilter.month:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case DateRangeFilter.year:
        startDate = DateTime(now.year, 1, 1);
        break;
    }

    return allUserTransactions.where((tx) {
      return tx.date.isAfter(startDate.subtract(const Duration(seconds: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Entire screen with a gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            transform: GradientRotation(183.33 * pi / 180),
            colors: [
              const Color(0xFFFFF6E6), // #FFF6E6
              Color.fromRGBO(248, 237, 216, 0), // rgba(248,237,216,0)
            ],
            stops: const [0.0956, 1.0],
          ),
        ),
        child: SafeArea(
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
                  _buildIncomeExpenseSection(),
                  const SizedBox(height: 20),
                  _buildDateRangeFilter(),
                  const SizedBox(height: 20),
                  _buildRecentTransactionsHeader(),
                  const SizedBox(height: 10),
                  _buildRecentTransactions(),
                ],
              ),
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
          // Additional navigation logic can be added for other indexes.
        },
      ),
    );
  }

  /// Top Bar: Avatar, Month Dropdown, Notification Icon, and Account Balance.
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: const AssetImage('assets/profile.jpg'),
              ),
              Row(
                children: [
                  Text(
                    DateFormat('MMMM').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey[700],
                  ),
                ],
              ),
              Icon(Icons.notifications_rounded, color: const Color(0xFF7F3DFF)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Account Balance',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹$accountBalance',
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
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
                borderRadius: BorderRadius.circular(20),
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
                borderRadius: BorderRadius.circular(20),
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

  Widget _buildDateRangeFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDateFilterButton(DateRangeFilter.today, 'Today'),
        _buildDateFilterButton(DateRangeFilter.week, 'Week'),
        _buildDateFilterButton(DateRangeFilter.month, 'Month'),
        _buildDateFilterButton(DateRangeFilter.year, 'Year'),
      ],
    );
  }

  Widget _buildDateFilterButton(DateRangeFilter filter, String label) {
    final bool isSelected = (_selectedFilter == filter);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF0DC) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.orange : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AllTransactionsScreen(
                      transactions: filteredTransactions,
                    ),
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

  Widget _buildRecentTransactions() {
    final transactionsToShow = filteredTransactions;
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: transactionsToShow.length,
        itemBuilder: (context, index) {
          return TransactionItem(transaction: transactionsToShow[index]);
        },
      ),
    );
  }
}
