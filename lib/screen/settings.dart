import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/login.dart';

const String removeMeQuery = """
    mutation removeMe {
      removeMe {
          id
        }
      }
  """;

class SettingScreen extends StatelessWidget {
  final User user;
  final s.Store? store;
  final Company? company;

  const SettingScreen(
      {Key? key, required this.user, required this.store, this.company})
      : super(key: key);

  removeMe(BuildContext context) async {
    QueryResult result = await GraphQL.client.mutate(MutationOptions(
      document: gql(removeMeQuery),
    ));

    if (result.data == null) {
      return;
    }

    // 1) delete the user via endpoint;
    // 2) log user out
    JumpStorage.storage.deleteAll();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final List<ListTile> tiles = [
      // ListTile(
      //   title: const Text("Members"),
      //   onTap: () {
      //     // Navigator.of(context).pushReplacement(PageRouteBuilder(
      //     //   pageBuilder: (context, animation1, animation2) => MembersScreen(
      //     //     user: user,
      //     //     store: store,
      //     //     company: company,
      //     //   ),
      //     //   transitionDuration: Duration.zero,
      //     //   reverseTransitionDuration: Duration.zero,
      //     // ));
      //   },
      // ),
      ListTile(
          title: const Text("Logout"),
          onTap: () => {
                JumpStorage.storage.deleteAll(),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false)
              }),
      ListTile(
          title: const Text("Delete my account"),
          onTap: () async => {await removeMe(context)}),
    ];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomeScreen(
                  user: user,
                  store: store,
                  company: company,
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ))
            },
          ),
        ),
        body: ListView.builder(
            itemCount: tiles.length,
            itemBuilder: (BuildContext context, int index) {
              return tiles[index];
            }));
  }
}
