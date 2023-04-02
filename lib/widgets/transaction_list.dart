import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction.dart';
import '../providers/transactions.dart';
import 'transaction_item.dart';

class TransactionList extends StatefulWidget {
  // final List<Transaction> transactions;
  // final Function deleteTx; // a pointer to "_deleteTransaction" function

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<Transactions>(context, listen: true);
    return transactions.userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.custom(
            childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return TransactionItem(
                  transaction: transactions.userTransactions[index],
                  key: ValueKey<Transaction>(
                      transactions.userTransactions[index]),
                  deleteTx: transactions.deleteTransaction,
                );
              },
              childCount: transactions.userTransactions.length,
              findChildIndexCallback: (Key key) {
                final ValueKey<Transaction> valueKey =
                    key as ValueKey<Transaction>;
                final Transaction data = valueKey.value;
                return transactions.userTransactions.indexOf(data);
              },
            ),
          );
  }
}
