import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/credit.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/credit_phone_verification.dart';
import 'package:greece/screen/credit_redemption_review.dart';

class CustomerNewScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  final User? customer;
  final Credit credit;

  CustomerNewScreen(
      {Key? key,
      this.customer,
      required this.user,
      this.store,
      this.company,
      required this.credit})
      : super(key: key);

  @override
  CustomerDetailsScreenState createState() => CustomerDetailsScreenState();
}

const String createCustomerQuery = """
  mutation createCustomer(\$phone: String!, \$full_name: String!) {
    createCustomer(phone: \$phone, full_name: \$full_name) {
      id,
      full_name, 
      credit_score
    }
  }
  """;

class CustomerDetailsScreenState extends State<CustomerNewScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  createCustomer() async {
    QueryResult result = await GraphQL.client.mutate(MutationOptions(
      document: gql(createCustomerQuery),
      variables: {
        'full_name': fullNameController.text,
        'phone': phoneController.text,
      },
    ));

    User customer = User.fromJson(result.data?["createCustomer"]);

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => CreditRedemptionScreen(
          user: widget.user,
          store: widget.store,
          customer: customer,
          credit: widget.credit,
          company: widget.company),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  @override
  void initState() {
    fullNameController = TextEditingController(text: widget.customer?.fullName);
    phoneController = TextEditingController(text: widget.customer?.phone);
    // addressController = TextEditingController(text: 'Address');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add new customer"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    CreditPhoneVerificationScreen(
                        user: widget.user,
                        store: widget.store,
                        credit: widget.credit,
                        company: widget.company),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ))
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Colors.redAccent,
                      primaryColorDark: Colors.red,
                    ),
                    child: TextField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.teal)),
                          // hintText: 'Full name',
                          // helperText: 'Keep it short, this is just a demo.',
                          labelText: 'Full name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          prefixText: ' ',
                          // suffixText: 'USD',
                          suffixStyle: TextStyle(color: Colors.green)),
                    ),
                  )),
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
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ))),
                            onPressed: () async {
                              await createCustomer();
                            },
                            child: const Text('Create customer',
                                style: TextStyle(fontSize: 20)),
                          ))))
            ]),
          ),
        ));
  }
}
