import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Make sure everything is filled!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay!'),
            ),
          ],
        ),
      );
      return;
    } else {
      widget.onAddExpense(Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 48, 16, keyBoardSpace + 16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              style: GoogleFonts.sen(color: Colors.black),
              decoration: InputDecoration(
                label:
                    Text('Title', style: GoogleFonts.sen(color: Colors.black)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.sen(color: Colors.black),
                    decoration: InputDecoration(
                      prefixText: '₹',
                      label: Text('Amount',
                          style: GoogleFonts.sen(color: Colors.black)),
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        _selectedDate == null
                            ? 'Not selected'
                            : formatter.format(_selectedDate!),
                        style: GoogleFonts.sen(color: Colors.black)),
                    IconButton(
                        onPressed: _showDatePicker,
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Color.fromARGB(255, 96, 116, 249),
                        )),
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color.fromARGB(255, 96, 116, 249),
                  ),
                  style: GoogleFonts.sen(
                    color: Colors.black,
                  ),
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitExpenseData,
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFFf96060))),
                  child: Text('Save expense',
                      style: GoogleFonts.sen(
                        color: Colors.white,
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFf96060))),
                    child: Text('Cancel',
                        style: GoogleFonts.sen(color: Colors.white)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
