import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/loan.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/loans.dart';
import 'package:intl/intl.dart';

class LoanDetailsScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  final Loan loan;

  LoanDetailsScreen(
      {Key? key,
      required this.store,
      required this.loan,
      required this.user,
      required this.company})
      : super(key: key);

  @override
  LoanDetailsScreenState createState() => LoanDetailsScreenState();
}

class LoanDetailsScreenState extends State<LoanDetailsScreen> {
  late TextEditingController amountController;
  late TextEditingController discountController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Loan details"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomeScreen(
                    user: widget.user,
                    store: widget.store,
                    company: widget.company),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ))
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            // Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(loan.applied_at) +
            //     " - " +
            //     loan.message),
            // Text(NumberFormat.simpleCurrency(
            //         locale: "en_US", name: "TSh", decimalDigits: 2)
            //     .format(loan.amount)),
            // Expanded(
            //     child: Align(
            //         alignment: Alignment.bottomCenter,
            //         child: SizedBox(
            //             height: 50,
            //             width: double.infinity, // <-- match_parent
            //             child: ElevatedButton(
            //               style: ButtonStyle(
            //                   shape: MaterialStateProperty.all<
            //                           RoundedRectangleBorder>(
            //                       RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(5.0),
            //               ))),
            //               onPressed: () {
            //                 removeExpense();
            //               },
            //               child: const Text('Delete',
            //                   style: TextStyle(fontSize: 20)),
            //               // color: Colors.blue,
            //               // textColor: Colors.white,
            //               // elevation: 5,
            //             ))))
          ]),
        ));
  }
}
