import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/transactions.dart';
import '../widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Transactions transactions;

  const NewTransaction(this.transactions, {super.key});

  @override
  State<NewTransaction> createState() {
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context, // context is reffered to Class context
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      // Once the user choose a date
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    // print('...');
  }

  void _submitData(Transactions transactions) {
    transactions.submitData(_titleController.text,
        double.parse(_amountController.text), _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<Transactions>(context, listen: false);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            // viewInsets: gives us info about anything lapping into view(soft kb).
            // bottom: how much space is occupied by the keyboard
            // Adjust the bottom padding of the card by the kb space + 10
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(transactions),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(
                    transactions), // _ means that it's not an important argument and we dont' need use it.
                // onChanged: (val) => amountInput = val,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () => _submitData(transactions),
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
