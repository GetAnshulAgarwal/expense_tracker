import 'package:assignment_cs/Screens/signup_screen.dart';
import 'package:assignment_cs/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/home_screen.dart';
import 'model/financial_data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(FinancialSummaryAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open Hive Boxes
  await Hive.openBox<FinancialSummary>('summaryBox');
  await Hive.openBox<TransactionModel>('transactionsBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: WelcomeScreen());
  }
}
