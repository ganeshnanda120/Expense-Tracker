import 'package:flutter/material.dart';
import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> expenses = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  double get totalExpenses => expenses.fold(0, (sum, expense) => sum + expense.amount);

  Widget _buildTextFields() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Expense Title',
            hintText: 'e.g., Food, Transport',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.receipt),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount (₹)',
            hintText: 'e.g., 100.50',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.currency_rupee),
          ),
        ),
      ],
    );
  }

  void showAddExpenseDialog() {
    titleController.clear();
    amountController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
return AlertDialog(
          title: const Text('Add Expense'),
          content: SingleChildScrollView(child: _buildTextFields()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => addExpense(context),
              child: const Text('Add Expense'),
            ),
          ],
        );
      },
    );
  }

  void addExpense(BuildContext context) {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();

    // Validation
    if (title.isEmpty) {
      showErrorSnackBar('Please enter an expense title');
      return;
    }

    if (amountText.isEmpty) {
      showErrorSnackBar('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      showErrorSnackBar('Please enter a valid amount greater than zero');
      return;
    }

    setState(() {
      expenses.add(
        Expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          amount: amount,
          dateTime: DateTime.now(),
        ),
      );
    });

    Navigator.of(context).pop();
    showSuccessSnackBar('Expense added successfully');
  }

  void showEditExpenseDialog(int index) {
    final expense = expenses[index];
    titleController.text = expense.title;
    amountController.text = expense.amount.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Expense'),
          content: SingleChildScrollView(child: _buildTextFields()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => updateExpense(context, index),
              child: const Text('Update Expense'),
            ),
          ],
        );
      },
    );
  }

  void updateExpense(BuildContext context, int index) {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();

    // Validation
    if (title.isEmpty) {
      showErrorSnackBar('Please enter an expense title');
      return;
    }

    if (amountText.isEmpty) {
      showErrorSnackBar('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      showErrorSnackBar('Please enter a valid amount greater than zero');
      return;
    }

    setState(() {
      expenses[index] = Expense(
        id: expenses[index].id,
        title: title,
        amount: amount,
        dateTime: expenses[index].dateTime,
      );
    });

    Navigator.of(context).pop();
    showSuccessSnackBar('Expense updated successfully');
  }

  void deleteExpense(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Expense?'),
          content: Text(
            'Are you sure you want to delete "${expenses[index].title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  expenses.removeAt(index);
                });
                Navigator.of(context).pop();
                showSuccessSnackBar('Expense deleted');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Total Spent',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${totalExpenses.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${expenses.length} expense${expenses.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? buildEmptyState()
                : buildExpenseList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddExpenseDialog,
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Expenses Added Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first expense',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExpenseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: Colors.blueAccent,
              ),
            ),
            title: Text(
              expense.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              expense.formattedDateTime,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                Text(
                  expense.formattedAmount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => showEditExpenseDialog(index),
                  tooltip: 'Edit Expense',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteExpense(index),
                  tooltip: 'Delete Expense',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
