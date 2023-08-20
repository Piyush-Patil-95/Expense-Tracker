import 'package:expense_tracker/widgets/new_expenses.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  void _buttonClick() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints.tight(Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * .8)),
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Expense Deleted',
        style: GoogleFonts.sen(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //print(MediaQuery.of(context).size.height);
    Widget mainContent = Center(
        child: Text(
      "No data entered.",
      style: GoogleFonts.sen(color: Colors.white, fontSize: 16),
    ));
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, onRemoveExpense: _removeExpense);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Expense Tracker',
            style: GoogleFonts.sen(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFf96060),
          actions: [
            IconButton(
                onPressed: _buttonClick,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: mainContent,
                  )
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: _registeredExpenses),
                  ),
                  Expanded(
                    child: mainContent,
                  )
                ],
              ));
  }
}
