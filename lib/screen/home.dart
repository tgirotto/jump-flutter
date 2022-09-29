import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/loans.dart';
import 'package:greece/screen/login.dart';
import 'package:greece/screen/members.dart';
import 'package:greece/screen/settings.dart';

const String removeMeQuery = """
    mutation removeMe {
      removeMe {
          id
        }
      }
  """;

class HomeScreen extends StatelessWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  const HomeScreen(
      {Key? key, required this.user, this.store, required this.company})
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
        title: const Text("Loans"),
        onTap: () {
          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => LoansScreen(
              user: user,
              store: store,
              company: company,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
        },
      ),
    ];

    Widget horizontalList1 = new Container(
        // margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              width: 160.0,
              color: Colors.red,
            ),
            Container(
              margin: EdgeInsets.only(right: 5),
              width: 160.0,
              color: Colors.orange,
            ),
            Container(
              margin: EdgeInsets.only(right: 5),
              width: 160.0,
              color: Colors.pink,
            ),
            Container(
              margin: EdgeInsets.only(right: 5),
              width: 160.0,
              color: Colors.yellow,
            ),
          ],
        ));

    return Scaffold(
        appBar: AppBar(
            title: const Text('Home'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        SettingScreen(
                            user: user, store: store, company: company),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
                },
              ),
            ]),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 150,
                    child: Center(child: Text("Your credit score is 5.4")),
                  )),
              horizontalList1,
              Text("Your pending loans"),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
              Card(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Container(
                    height: 50,
                    child: Center(child: Text("Tommaso Girotto owes you xxx")),
                  )),
            ],
          ),
        ));
  }
}
