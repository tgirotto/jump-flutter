import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/edge.dart';
import 'package:greece/model/page.dart' as p;
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/settings.dart';
import 'package:greece/screen/stores.dart';

class CompaniesScreen extends StatefulWidget {
  final User user;
  final s.Store? store;

  const CompaniesScreen({super.key, required this.user, this.store});
  @override
  CompaniesScreenState createState() => CompaniesScreenState();
}

class CompaniesScreenState extends State<CompaniesScreen> {
  final pageSize = 20;
  late p.Page<Company> page;
  late FetchMoreOptions opts;
  late QueryResult result;
  late List<Company> companies = [];

  late FetchMore? fetchMore;

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Companies', style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Show Snackbar',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingScreen(
                            user: widget.user,
                            store: widget.store,
                          )),
                );
              },
            ),
          ]),
      body: Query(
          options: QueryOptions(
            document: gql(GET_COMPANIES),
            variables: {'first': pageSize, 'after': ""},
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
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

            page = p.Page<Company>.fromJson(
                result.data?['getCompanies']['page'], Company.fromJson);

            companies = page.edges.map((Edge<Company> e) => e.node).toList();

            // final Map pageInfo = result.data['search']['pageInfo'];
            String? fetchMoreCursor = page.pageInfo.endCursor;

            FetchMoreOptions opts = FetchMoreOptions(
              variables: {'after': fetchMoreCursor, 'first': pageSize},
              updateQuery: (previousResultData, fetchMoreResultData) {
                // this is where you combine your previous data and response
                // in this case, we want to display previous repos plus next repos
                // so, we combine data in both into a single list of repos
                final List<dynamic> repos = [
                  ...previousResultData?['getCompanies']['page']['edges']
                      as List<dynamic>,
                  ...fetchMoreResultData?['getCompanies']['page']['edges']
                      as List<dynamic>
                ];

                fetchMoreResultData?['getCompanies']['page']['edges'] = repos;

                return fetchMoreResultData;
              },
            );

            if (companies.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/searching.png",
                      width: size.width, height: 200),
                  const Text("No stores found")
                ],
              );
            } else {
              return NotificationListener(
                onNotification: (dynamic t) {
                  if (t is ScrollEndNotification &&
                      scrollController.position.pixels >=
                          scrollController.position.maxScrollExtent * 0.9 &&
                      page.pageInfo.hasNextPage &&
                      !result.isLoading) {
                    fetchMore!(opts);
                  }
                  return true;
                },
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: companies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(companies[index].name[0].toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                        subtitle: Text(companies[index].name),
                        title: Text(companies[index].name),
                        // trailing: const Icon(Icons.add),
                        onTap: () => {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                StoresScreen(
                                    user: widget.user,
                                    company: companies[index],
                                    store: widget.store),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ))
                        },
                      );
                    }),
              );
            }
          }),
    );
  }
}

String GET_COMPANIES = """
  query getCompanies(\$first: Float!, \$after: String!) {
    getCompanies(first: \$first, after: \$after) {
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
