import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/edge.dart';
import 'package:greece/model/page.dart' as p;
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/member_new.dart';

class MembersScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company company;
  const MembersScreen(
      {super.key, required this.user, this.store, required this.company});
  @override
  MembersScreenState createState() => MembersScreenState();
}

class MembersScreenState extends State<MembersScreen> {
  final pageSize = 1000;
  late p.Page<User> page;
  late FetchMoreOptions opts;
  late QueryResult result;
  late FetchMore? fetchMore;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Staff'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomeScreen(
                  user: widget.user,
                  store: widget.store,
                  company: widget.company,
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ))
            },
          ),
        ),
        body: Query(
            options: QueryOptions(
              document: gql(members),
              variables: {
                'first': pageSize,
                'after': "",
                'store': {'id': widget.store?.id}
              },
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              //atrocious
              this.result = result;
              this.fetchMore = fetchMore;

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

              page = p.Page<User>.fromJson(
                  result.data?['getMembersByCompany']['page'], User.fromJson);

              final List<User> members =
                  page.edges.map((Edge<User> e) => e.node).toList();

              // final Map pageInfo = result.data['search']['pageInfo'];
              String? fetchMoreCursor = page.pageInfo.endCursor;

              opts = FetchMoreOptions(
                variables: {
                  'after': fetchMoreCursor,
                  'first': pageSize,
                  'store': {'id': widget.store?.id}
                },
                updateQuery: (previousResultData, fetchMoreResultData) {
                  // this is where you combine your previous data and response
                  // in this case, we want to display previous repos plus next repos
                  // so, we combine data in both into a single list of repos
                  final List<dynamic> repos = [
                    ...previousResultData?['getMembersByCompany']['page']
                        ['edges'] as List<dynamic>,
                    ...fetchMoreResultData?['getMembersByCompany']['page']
                        ['edges'] as List<dynamic>
                  ];

                  fetchMoreResultData?['getMembersByCompany']['page']['edges'] =
                      repos;

                  return fetchMoreResultData;
                },
              );

              return ListView.builder(
                  controller: _scrollController,
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(members[index].fullName),
                      subtitle: Text(members[index].userType as String),
                      onTap: () => {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => MemberDetailsScreen(
                        //               user: widget.user,
                        //               member: members[index],
                        //               store: widget.store,
                        //             )))
                      },
                    );
//                 }
                  });
            }),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: const Icon(Icons.add),
            // backgroundColor: new Color(0xFFE57373),
            onPressed: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    NewMemberScreen(
                  user: widget.user,
                  store: widget.store,
                  company: widget.company,
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ));
            }));
  }
}

String members = """
  query getMembersByCompany(\$first: Float!, \$after: String!, \$company: MapCompanyInput!) {
    getMembersByCompany(first: \$first, after: \$after, company: \$company) {
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
              full_name,
              company {
                id,
                name
              },
              user_type {
                id,
                name
              }
            }
          }
      }
    }
  }
""";
