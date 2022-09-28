import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/members.dart';

class MemberDetailsScreen extends StatefulWidget {
  final User user;
  final User? member;
  final s.Store store;
  final Company company;

  const MemberDetailsScreen(
      {Key? key,
      this.member,
      required this.user,
      required this.store,
      required this.company})
      : super(key: key);

  @override
  CustomerDetailsScreenState createState() => CustomerDetailsScreenState();
}

String updateUserDetailsQuery = """
  mutation updateUser(\$updateUserInput: UpdateUserInput!) {
    updateUser(updateUserInput: \$updateUserInput) {
      id,
      full_name
    }
  }
  """;

class CustomerDetailsScreenState extends State<MemberDetailsScreen> {
  TextEditingController? fullNameController;
  TextEditingController? phoneController;
  TextEditingController? emailController;
  // TextEditingController? addressController;

  updateUser() async {
    await GraphQL.client.mutate(MutationOptions(
      document: gql(updateUserDetailsQuery),
      variables: {
        'updateUserInput': {
          'id': widget.member?.id,
          'full_name': fullNameController?.text,
          'email': emailController?.text,
          'phone': phoneController?.text,
        }
      },
    ));
  }

  @override
  void initState() {
    fullNameController = TextEditingController(text: widget.member?.fullName);
    emailController = TextEditingController(text: widget.member?.email);
    phoneController = TextEditingController(text: widget.member?.phone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: MyNavbar(
        //   myTitle: "Member details",
        //   myContext: context,
        //   user: widget.user,
        //   back: true,
        // ),
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
                  controller: phoneController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      // hintText: 'Full name',
                      // helperText: 'Keep it short, this is just a demo.',
                      labelText: 'Phone',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      prefixText: ' ',
                      // suffixText: 'USD',
                      suffixStyle: TextStyle(color: Colors.green)),
                ),
              )),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      height: 50,
                      width: double.infinity, // <-- match_parent
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ))),
                        onPressed: () async {
                          await this.updateUser();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MembersScreen(
                                      user: widget.user,
                                      store: widget.store,
                                      company: widget.company)));
                        },
                        child:
                            const Text('Save', style: TextStyle(fontSize: 20)),
                        // color: Colors.blue,
                        // textColor: Colors.white,
                        // elevation: 5,
                      ))))
        ]),
      ),
    ));
  }
}
