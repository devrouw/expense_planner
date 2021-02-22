import 'dart:io';

import 'package:flutter/cupertino.dart';

import './widget/chart.dart';
import 'package:flutter/material.dart';

import './widget/transaction_list.dart';
import './models/transaction.dart';
import './widget/input_transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
          fontFamily: 'Quicksand',
          primarySwatch: Colors.purple,
          errorColor: Colors.red,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(fontFamily: 'OpenSans', fontSize: 20)),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  final List<Transaction> _userTransaction = [];

  bool _showChart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }


  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  List<Transaction> get _recentTx {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _updateData(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

//  final titleController = TextEditingController();
//  final amountController = TextEditingController();

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: InputTransaction(_updateData),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _isLandscape(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTx))
          : txListWidget
    ];
  }

  List<Widget> _isPotrait(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTx),
      ),
      txListWidget
    ];
  }

  Widget _buildAppBar(){
    return Platform.isIOS ? CupertinoNavigationBar(
      middle: Text(
        "Expense Planner",
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => startAddNewTransaction(context),
          )
        ],
      ),
    ): AppBar(
      title: Text(
        "Expense Planner",
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );
  }

//  Widget thisAppbar(){
//    return AppBar(
//      title: Text(
//        "Expense Planner",
//      ),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.add),
//          onPressed: () => startAddNewTransaction(context),
//        )
//      ],
//    );
//  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = _buildAppBar();
//    Platform.isIOS
//        ? CupertinoNavigationBar(
//            middle: Text(
//              "Expense Planner",
//            ),
//            trailing: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                GestureDetector(
//                  child: Icon(CupertinoIcons.add),
//                  onTap: () => startAddNewTransaction(context),
//                )
//              ],
//            ),
//          )
//        : AppBar(
//            title: Text(
//              "Expense Planner",
//            ),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.add),
//                onPressed: () => startAddNewTransaction(context),
//              )
//            ],
//          );
    // TODO: implement build
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));

    final finalBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._isLandscape(mediaQuery, appBar, txListWidget),
            if (!isLandscape) ..._isPotrait(mediaQuery, appBar, txListWidget),
//          if (!isLandscape) txListWidget,
//          if (isLandscape)
//            _showChart
//                ? Container(
//                    height: (mediaQuery.size.height -
//                            appBar.preferredSize.height -
//                            mediaQuery.padding.top) *
//                        0.3,
//                    child: Chart(_recentTx))
//                : txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: finalBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: finalBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => startAddNewTransaction(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
