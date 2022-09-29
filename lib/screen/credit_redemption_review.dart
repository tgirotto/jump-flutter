import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/customer_new.dart';
import 'package:greece/screen/home.dart';

class CreditRedemptionScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  final Credit credit;
  final User customer;

  CreditRedemptionScreen(
      {Key? key,
      required this.store,
      required this.customer,
      required this.credit,
      required this.user,
      required this.company})
      : super(key: key);

  @override
  CreditRedemptionScreenState createState() => CreditRedemptionScreenState();
}

class CreditRedemptionScreenState extends State<CreditRedemptionScreen> {
  late TextEditingController phoneController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  final String searchUserQuery = """
  query searchUser(\$phone: String!) {
    searchUser(phone: \$phone) {
      id,
      full_name,
      credit_score
    }
  }
  """;
  bool isLoading = false;
  int searchCount = 0;
  User? searchedUser;

  Future searchUser() async {
    setState(() {
      searchCount++;
      isLoading = true;
    });

    QueryResult result = await GraphQL.client.mutate(MutationOptions(
      document: gql(searchUserQuery),
      variables: {'phone': "+255${phoneController.text}"},
    ));

    if (result.data == null || result.data!['searchUser'] == null) {
      setState(() {
        isLoading = false;
        searchedUser = null;
      });
      return;
    }

    User user = User.fromJson(result.data?['searchUser']);
    setState(() {
      isLoading = false;
      searchedUser = user;
    });
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) =>
    //             ExpensesScreen(widget.user, widget.store, widget.company)),
    //     (route) => false);
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
