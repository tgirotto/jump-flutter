import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/customer_new.dart';
import 'package:greece/screen/home.dart';

class CreditRedemptionConfirmationScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;

  CreditRedemptionConfirmationScreen(
      {Key? key,
      required this.store,
      required this.user,
      required this.company})
      : super(key: key);

  @override
  CreditRedemptionConfirmationScreenState createState() =>
      CreditRedemptionConfirmationScreenState();
}

class CreditRedemptionConfirmationScreenState
    extends State<CreditRedemptionConfirmationScreen> {
  late TextEditingController phoneController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirmed"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Success!",
                style: TextStyle(fontSize: 40),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Our agents will send you the funds shortly.",
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "The customer will receive an SMS with the details of the loan",
              ),
            ),
          ],
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => HomeScreen(
                user: widget.user,
                store: widget.store,
                company: widget.company),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.shopping_bag),
        label: const Text("Back to home"),
      ),
    );
  }
}
