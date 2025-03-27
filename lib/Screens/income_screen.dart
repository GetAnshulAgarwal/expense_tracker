import 'package:flutter/material.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedWallet;

  final List<String> _categories = ['Office', 'Freelance', 'Salary', 'Other'];
  final List<String> _wallets = [
    'Bank Account',
    'Cash',
    'PayPal',
    'Credit Card',
  ];

  void _validateAndContinue() {
    final double? amount = double.tryParse(
      _amountController.text.replaceAll('₹', '').trim(),
    );

    if (amount == null || amount <= 0) {
      _showErrorSnackBar("Please enter a valid amount");
      return;
    }

    if (_selectedCategory == null) {
      _showErrorSnackBar("Please select a category");
      return;
    }

    if (_selectedWallet == null) {
      _showErrorSnackBar("Please select a wallet");
      return;
    }

    Navigator.of(context).pop({
      'amount': amount,
      'category': _selectedCategory,
      'description': _descriptionController.text,
      'wallet': _selectedWallet,
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF7B61FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Income',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100),

            // Purple Top Section: "How much?" + big amount input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How much?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              ),
            ),

            // White Bottom Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                // We use a Stack so we can pin the "Continue" button at the bottom
                child: Stack(
                  children: [
                    // Scrollable content for category, description, wallet
                    SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        MediaQuery.of(context).viewInsets.bottom + 100,
                        // Extra bottom padding so fields aren't covered by the button
                      ),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildDropdown(
                            'Category',
                            _categories,
                            _selectedCategory,
                            (value) =>
                                setState(() => _selectedCategory = value),
                          ),
                          const SizedBox(height: 15),
                          _buildDescriptionField(),
                          const SizedBox(height: 15),
                          _buildDropdown(
                            'Wallet',
                            _wallets,
                            _selectedWallet,
                            (value) => setState(() => _selectedWallet = value),
                          ),
                          const SizedBox(height: 20),
                          // Add more fields if needed
                        ],
                      ),
                    ),
                    // Positioned "Continue" button at the bottom
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: _buildContinueButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
  ) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
          value: selectedValue,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(item, style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Description',
          hintStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _validateAndContinue,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7B61FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'Continue',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
