import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimized_personal_expense/providers/transactions.dart';
import 'package:provider/provider.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized()
  // SystemChrome allows us to set some application light or system wide settings for the app
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Transactions(),
        ),
      ],
      child: MaterialApp(
        title: 'Personal Expenses',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.amber,
            error: Colors.red,
          ),
          appBarTheme: theme.appBarTheme.copyWith(
            titleTextStyle: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: theme.textTheme.copyWith(
            titleLarge: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  void _startAddNewTransaction(BuildContext ctx) {
    final myModel = Provider.of<Transactions>(ctx, listen: false);
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(myModel),
        );
      },
    );
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Container txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Switch.adaptive(
            // automatically adjust the look based on the platform
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery,
      PreferredSizeWidget appBar, Container txListWidget) {
    return [
      SizedBox(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLanscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Personal Expense',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, // The Row will shrink along the main axis from left to right
              children: <Widget>[
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              (appBar as PreferredSizeWidget).preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(),
    );

    final pageBody = SafeArea(
      // Make sure things are positioned within boundaries respecting reserved areas.
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLanscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLanscape) // Note: in array or list, don't use curly braces for statements
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
