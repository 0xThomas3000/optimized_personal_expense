import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './transaction.dart';

class Transactions with ChangeNotifier {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get userTransactions {
    return [..._userTransactions];
  }

  List<Transaction> get recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    _userTransactions.add(newTx);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _userTransactions.removeWhere((tx) {
      return tx.id == id;
    });
    notifyListeners();
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  void submitData(
      String enteredTitle, double enteredAmount, DateTime? selectedDate) {
    if (enteredAmount.toString().isEmpty) {
      return;
    }

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    addNewTransaction(
      // widget helps us to access addTx property from another class
      enteredTitle,
      enteredAmount,
      selectedDate,
    );
  }
}
