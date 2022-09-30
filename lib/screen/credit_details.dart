import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/loan.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/credit_phone_verification.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/loans.dart';
import 'package:intl/intl.dart';

class CreditDetailsScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  final Credit credit;

  CreditDetailsScreen(
      {Key? key,
      required this.store,
      required this.credit,
      required this.user,
      required this.company})
      : super(key: key);

  @override
  CreditDetailsScreenState createState() => CreditDetailsScreenState();
}

class CreditDetailsScreenState extends State<CreditDetailsScreen> {
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
        title: const Text("Credit details"),
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
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text(
                "Principal: " +
                    NumberFormat.simpleCurrency(
                            locale: "en_US", name: "TSh", decimalDigits: 2)
                        .format(widget.credit.principal),
                // style: TextStyle(fontSize: 30),
              ),
              Text(
                "Interest: " + widget.credit.interest.toString() + "%",
                // style: TextStyle(fontSize: 30),
              ),
              Text("Loan length: " +
                  widget.credit.period_days.toString() +
                  " days")
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
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (widget.credit.creditStatus == 'INITIALISED')
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      CreditPhoneVerificationScreen(
                          user: widget.user,
                          store: widget.store,
                          credit: widget.credit,
                          company: widget.company),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
              },
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.shopping_bag),
              label: const Text("Check credit score"),
            )
          : Container(),
    );
  }
}
