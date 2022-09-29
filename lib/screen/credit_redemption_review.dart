import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/credit_redemption_confirmation.dart';
import 'package:greece/screen/customer_new.dart';
import 'package:greece/screen/home.dart';

class CreditRedemptionReviewScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  final Credit credit;
  final User customer;

  CreditRedemptionReviewScreen(
      {Key? key,
      required this.store,
      required this.customer,
      required this.credit,
      required this.user,
      required this.company})
      : super(key: key);

  @override
  CreditRedemptionReviewScreenState createState() =>
      CreditRedemptionReviewScreenState();
}

class CreditRedemptionReviewScreenState
    extends State<CreditRedemptionReviewScreen> {
  late TextEditingController phoneController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  final String searchUserQuery = """
  mutation createLoan(\$credit_id: Int!, \$customer_id: Int!) {
    createLoan(credit_id: \$credit_id, customer_id: \$customer_id) {
      id
    }
  }
  """;
  bool isLoading = false;

  Future createLoan() async {
    setState(() {
      isLoading = true;
    });

    QueryResult result = await GraphQL.client
        .mutate(MutationOptions(document: gql(searchUserQuery), variables: {
      'credit_id': widget.credit.id,
      'customer_id': widget.customer.id,
    }));

    if (result.data == null || result.data!['createLoan'] == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) =>
          CreditRedemptionConfirmationScreen(
              user: widget.user, store: widget.store, company: widget.company),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm"),
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
          Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.redAccent,
                    primaryColorDark: Colors.red,
                  ),
                  child: Text("Loan to: ${widget.customer.fullName}"))),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          createLoan();
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => CheckoutReviewScreen(
          //               user: widget.user,
          //               basket: widget.basket,
          //               company: widget.company,
          //               store: widget.store,
          //             )));
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.shopping_bag),
        label: const Text("Send request!"),
      ),
    );
  }
}
