import 'package:expenseplanner/widget/transaction_list_item.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//class TransactionList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return _TransactionListState();
//  }
//
//}

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransaction;
  final Function deleteTx;

  TransactionList(this._userTransaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return _userTransaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No Transaction Added Yet',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 60,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(transactions: _userTransaction[index], deleteTx: deleteTx);
            },
            itemCount: _userTransaction.length,
          );
  }
}
