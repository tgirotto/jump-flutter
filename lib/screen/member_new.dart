import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/edge.dart';
import 'package:greece/model/page.dart' as p;
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/members.dart';

class NewMemberScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;

  const NewMemberScreen(
      {Key? key, required this.user, this.store, required this.company})
      : super(key: key);

  @override
  CustomerDetailsScreenState createState() => CustomerDetailsScreenState();
}

String createUserDetailsQuery = """
  mutation createMember(\$createMemberInput: CreateMemberInput!) {
    createMember(createMemberInput: \$createMemberInput) {
      id,
      full_name
      phone,
      email,
    }
  }
  """;

String getUserTypesQuery = """
  query userTypes(\$first: Float!, \$after: String!) {
    userTypes(first: \$first, after: \$after) {
      page {
        pageInfo {
            startCursor,
            endCursor,
            hasNextPage
        },
        edges {
          cursor
          node {
            id,
            name
          }
        }
      }
    }
  }
  """;

class CustomerDetailsScreenState extends State<NewMemberScreen> {
  User? member;
  TextEditingController? fullNameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");

  createUser() async {
    await GraphQL.client.mutate(MutationOptions(
      document: gql(createUserDetailsQuery),
      variables: {
        'createMemberInput': {
          'full_name': fullNameController?.text,
          'phone': "+255" + (phoneController.text),
          'store': {'id': widget.store?.id},
          'user_type': 'OWNER'
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: MyNavbar(
        //   myTitle: "New member",
        //   myContext: context,
        //   user: widget.user,
        //   back: true,
        // ),
        body: Query(
            options: QueryOptions(
              document: gql(getUserTypesQuery),
              variables: const {'first': 100, 'after': ''},
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Text('Loading');
              }

              // p.Page<String> page = p.Page<String>.fromJson(
              //     result.data?['userTypes']['page'], UserType.fromJson);
              return Padding(
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
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.teal)),
                                // hintText: 'Full name',
                                // helperText: 'Keep it short, this is just a demo.',
                                labelText: 'Full name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                                prefixText: ' ',
                                // suffixText: 'USD',
                                suffixStyle:
                                    const TextStyle(color: Colors.green)),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              // hintText: 'Full name',
                              // helperText: 'Keep it short, this is just a demo.',
                              labelText: 'Phone',
                              // prefixIcon: const Icon(
                              //   Icons.phone,
                              //   color: Colors.blue,
                              // ),
                              prefixText: '+255 ',
                              // suffixText: '',
                              // suffixStyle:
                              //     const TextStyle(color: Colors.green)
                            ),
                          ),
                        )),
                    // Padding(
                    //     padding: const EdgeInsets.only(top: 8.0),
                    //     child: DropdownButton<UserType>(
                    //       isExpanded: true,
                    //       value: userType,
                    //       items: page.edges.map((Edge<UserType> value) {
                    //         return DropdownMenuItem<UserType>(
                    //           value: value.node,
                    //           child: Text(value.node.name),
                    //         );
                    //       }).toList(),
                    //       onChanged: (e) {
                    //         setState(() {
                    //           userType = e;
                    //         });
                    //       },
                    //     )),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                                height: 50,
                                width: double.infinity, // <-- match_parent
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ))),
                                  onPressed: () async {
                                    await createUser();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => MembersScreen(
                                    //             user: widget.user,
                                    //             store: widget.store,
                                    //             company: widget.company)));
                                  },
                                  child: const Text('Save',
                                      style: TextStyle(fontSize: 20)),
                                  // color: Colors.blue,
                                  // textColor: Colors.white,
                                  // elevation: 5,
                                ))))
                  ]),
                ),
              );
            }));
  }
}
