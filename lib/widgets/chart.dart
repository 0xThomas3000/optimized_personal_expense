import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transactions.dart';
import './chart_bar.dart';

class Chart extends StatefulWidget {
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<Transactions>(context, listen: true);
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactions.groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'] as String,
                data['amount'] as double,
                transactions.totalSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / transactions.totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
