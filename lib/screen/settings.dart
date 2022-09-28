import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
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
  const SettingScreen({Key? key, required this.user, required this.store})
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
          automaticallyImplyLeading: true,
        ),
        body: ListView.builder(
            itemCount: tiles.length,
            itemBuilder: (BuildContext context, int index) {
              return tiles[index];
            }));
  }
}
