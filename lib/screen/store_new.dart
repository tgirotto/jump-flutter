import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/page.dart' as p;
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/stores.dart';

class NewStoreScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company company;

  NewStoreScreen(
      {Key? key, this.store, required this.user, required this.company})
      : super(key: key);

  @override
  NewStoreScreenState createState() => NewStoreScreenState();
}

const String createStoreQuery = """
  mutation createStore(\$createStoreInput: CreateStoreInput!) {
    createStore(createStoreInput: \$createStoreInput) {
      id,
      name,
      phone
    }
  }
  """;

class NewStoreScreenState extends State<NewStoreScreen> {
  TextEditingController nameController = TextEditingController(text: "");
  bool isLoading = false;
  String? error;

  final String getStoreTypesQuery = """
  query getStoreTypes(\$first: Float!) {
      getStoreTypes(first: \$first) {
          page {
            pageInfo {
              startCursor,
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

  Future createStore() async {
    if (nameController.text.trim().isEmpty) {
      setState(() {
        isLoading = false;
        error = "Invalid name";
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });
    await GraphQL.client.mutate(MutationOptions(
      document: gql(createStoreQuery),
      variables: {
        'createStoreInput': {
          'name': nameController.text,
          'company': {"id": widget.company.id},
          // 'store_type': {"id": storeType?.id},
        }
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: MyNavbar(
        //   myTitle: "New store",
        //   myContext: context,
        //   user: widget.user,
        //   back: true,
        // ),
        body: Query(
            options: QueryOptions(
              document: gql(getStoreTypesQuery),
              variables: const {
                'first': 100,
              },
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Text('Loading');
              }

              // Map<String, Object> data = result.data;
              // it can be either Map or List
              // List<User> customers = result.data;

              // p.Page<StoreType> page = P.Page<StoreType>.fromJson(
              //     result.data?['getStoreTypes']['page'], StoreType.fromJson);
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                              errorText: error != null ? error : null,
                              border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              // hintText: 'Full name',
                              // helperText: 'Keep it short, this is just a demo.',
                              labelText: 'Name',
                              // prefixIcon: const Icon(
                              //   Icons.person,
                              //   color: Colors.blue,
                              // ),
                              prefixText: ' ',
                              // suffixText: 'USD',
                              suffixStyle:
                                  const TextStyle(color: Colors.green)),
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
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ))),
                                  onPressed: () async {
                                    await createStore();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => StoresScreen(
                                    //             user: widget.user,
                                    //             company: widget.company,
                                    //             store: widget.user.store)));
                                  },
                                  child: const Text('Save',
                                      style: TextStyle(fontSize: 20)),
                                  // color: Colors.blue,
                                  // textColor: Colors.white,
                                  // elevation: 5,
                                ))))
                  ])));
            }));
  }
}
