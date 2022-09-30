import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/home.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/credit_details.dart';
import 'package:greece/screen/credits.dart';
import 'package:greece/screen/loan_details.dart';
import 'package:greece/screen/loans.dart';
import 'package:greece/screen/settings.dart';
import 'package:intl/intl.dart';

String homeQuery = """
  query getHome() {
    getHome() {
      company {
        name,
        vat,
        registration_number,
        id,
        credit_score
      },
      loans {
        id, 
        principal,
        loan_status,
        customer {
          id,
          full_name,
          credit_score
        }
      },
      credits {
        id,
        principal,
        interest,
        period_days,
        credit_status
      }
    }
  }
""";

class HomeScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  const HomeScreen(
      {super.key, required this.user, this.store, required this.company});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Home? home;

  @override
  Widget build(BuildContext context) {
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
                          user: widget.user,
                          store: widget.store,
                          company: widget.company),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
              },
            ),
          ]),
      body: Query(
          options: QueryOptions(
            document: gql(homeQuery),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            //atrocious
            // this.result = result;
            // this.fetchMore = fetchMore;

            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (result.hasException) {
              return const Text('\nErrors: \n  ');
            }

            if (result.data == null) {
              return const Text(
                  'Both data and errors are null, this is a known bug after refactoring, you might forget to set Github token');
            }

            home = Home.fromJson(result.data?['getHome']);

            List<Widget> widgets = [
              Card(
                margin: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: Container(
                    height: 150,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          home!.company!.creditScore.toString(),
                          style: TextStyle(fontSize: 40),
                        ),
                        Text("Your credit score")
                      ],
                    )),
                  ),
                ),
              ),
            ];

            widgets.add(TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        CreditsScreen(
                      user: widget.user,
                      store: widget.store,
                      company: widget.company,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
                },
                child: const Text(
                  "Your open credits",
                )));

            List<Widget> creditCards = home!.credits
                .map(
                  (e) => InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            CreditDetailsScreen(
                          user: widget.user,
                          store: widget.store,
                          credit: e,
                          company: widget.company,
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ));
                    },
                    child: Container(
                        margin: const EdgeInsets.only(right: 5),
                        width: 160.0,
                        color: Colors.red,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(NumberFormat.simpleCurrency(
                                      locale: "en_US",
                                      name: "TSh",
                                      decimalDigits: 2)
                                  .format(e.principal)),
                              Text(e.creditStatus)
                            ],
                          ),
                        )),
                  ),
                )
                .toList();

            Widget creditList = Container(
                // margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 200.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: creditCards,
                ));

            if (creditCards.isNotEmpty) {
              widgets.add(creditList);
            } else {
              widgets.add(
                Card(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      debugPrint('Card tapped.');
                    },
                    child: Container(
                      height: 150,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("No credits available")],
                      )),
                    ),
                  ),
                ),
              );
            }
            widgets.add(TextButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(PageRouteBuilder(
                //   pageBuilder: (context, animation1, animation2) => LoansScreen(
                //     user: widget.user,
                //     store: widget.store,
                //     company: widget.company,
                //   ),
                //   transitionDuration: Duration.zero,
                //   reverseTransitionDuration: Duration.zero,
                // ));
              },
              child: const Text(
                "Your pending loans",
              ),
            ));

            widgets.addAll(home!.loans.map(
              (e) => Card(
                margin: const EdgeInsets.only(bottom: 5),
                child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      // Navigator.of(context).pushReplacement(PageRouteBuilder(
                      //   pageBuilder: (context, animation1, animation2) =>
                      //       LoanDetailsScreen(
                      //     user: widget.user,
                      //     store: widget.store,
                      //     loan: e,
                      //     company: widget.company,
                      //   ),
                      //   transitionDuration: Duration.zero,
                      //   reverseTransitionDuration: Duration.zero,
                      // ));
                    },
                    child: Container(
                      height: 50,
                      child: Center(
                          child: Text(
                              "Tommaso Girotto owes you ${NumberFormat.simpleCurrency(locale: "en_US", name: "TSh", decimalDigits: 2).format(e.principal)}")),
                    )),
              ),
            ));
            return Padding(
              padding: EdgeInsets.all(5.0),
              child:
                  ListView(scrollDirection: Axis.vertical, children: widgets),
            );
          }),
    );
  }
}
