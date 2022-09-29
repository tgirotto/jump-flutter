import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/loan.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/customer_new.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/loans.dart';
import 'package:intl/intl.dart';

class CreditPhoneVerificationScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  final Credit credit;

  CreditPhoneVerificationScreen(
      {Key? key,
      required this.store,
      required this.credit,
      required this.user,
      required this.company})
      : super(key: key);

  @override
  CreditPhoneVerificationScreenState createState() =>
      CreditPhoneVerificationScreenState();
}

class CreditPhoneVerificationScreenState
    extends State<CreditPhoneVerificationScreen> {
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
        title: const Text("Verify credit"),
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
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      // hintText: 'Full name',
                      // helperText: 'Keep it short, this is just a demo.',
                      hintText: "",
                      prefixText: '+255 ',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      // suffixText: 'USD',
                      suffixStyle: TextStyle(color: Colors.green)),
                ),
              )),
          !isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ))),
                    onPressed: () {
                      searchUser();
                    },
                    child: const Text('Search', style: TextStyle(fontSize: 20)),
                    // color: Colors.blue,
                    // textColor: Colors.white,
                    // elevation: 5,
                  ))
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          (searchedUser != null)
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            searchedUser!.creditScore.toString(),
                            style: TextStyle(fontSize: 50),
                          ),
                          Text(
                            searchedUser!.fullName,
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      )))
              : (searchCount == 0)
                  ? Container(child: Text("Insert a phone number"))
                  : Container(
                      child: Column(
                      children: [
                        const Text("User not found"),
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  CustomerNewScreen(
                                      user: widget.user,
                                      store: widget.store,
                                      credit: widget.credit,
                                      company: widget.company),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ));
                          },
                          child: const Text('Add customer',
                              style: TextStyle(fontSize: 20)),
                          // color: Colors.blue,
                          // textColor: Colors.white,
                          // elevation: 5,
                        )
                      ],
                    ))
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
        label: const Text("Request loan!"),
      ),
    );
  }
}
