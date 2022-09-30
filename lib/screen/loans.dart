import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/model/company.dart';
import 'package:greece/model/edge.dart';
import 'package:greece/model/loan.dart';
import 'package:greece/model/page.dart' as p;
import 'package:greece/model/store.dart' as s;
import 'package:greece/model/user.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/loan_details.dart';
import 'package:greece/screen/member_new.dart';
import 'package:intl/intl.dart';

class LoansScreen extends StatefulWidget {
  final User user;
  final s.Store? store;
  final Company? company;
  const LoansScreen(
      {super.key, required this.user, this.store, required this.company});
  @override
  LoansScreenState createState() => LoansScreenState();
}

class LoansScreenState extends State<LoansScreen> {
  final pageSize = 100;
  int pageNumber = 0;
  late p.Page<Loan> page;
  late FetchMoreOptions opts;
  late QueryResult result;
  late FetchMore? fetchMore;

  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
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
              'offset': pageSize * pageNumber,
              'limit': pageSize,
              'company_id': widget.company?.id
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

            page =
                p.Page<Loan>.fromJson(result.data?['getLoans'], Loan.fromJson);

            final List<Loan> loans =
                page.entries.map((Entry<Loan> e) => e.node).toList();

            opts = FetchMoreOptions(
              variables: {
                'offset': pageSize * pageNumber,
                'limit': pageSize,
                'company_id': widget.company?.id
              },
              updateQuery: (previousResultData, fetchMoreResultData) {
                // this is where you combine your previous data and response
                // in this case, we want to display previous repos plus next repos
                // so, we combine data in both into a single list of repos
                final List<dynamic> repos = [
                  ...previousResultData?['getLoans']['entries']
                      as List<dynamic>,
                  ...fetchMoreResultData?['getLoans']['entries']
                      as List<dynamic>
                ];

                fetchMoreResultData?['getLoans']['page']['edges'] = repos;

                return fetchMoreResultData;
              },
            );

            return NotificationListener(
                onNotification: (dynamic t) {
                  if (t is ScrollEndNotification &&
                      scrollController.position.pixels >=
                          scrollController.position.maxScrollExtent * 0.9 &&
                      page.pageInfo.limit * page.pageInfo.offset <
                          page.pageInfo.total &&
                      !result.isLoading) {
                    fetchMore!(opts);
                  }
                  return true;
                },
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: loans.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(loans[index].customer!.fullName +
                            " - " +
                            loans[index].loanStatus),
                        subtitle: Text(NumberFormat.simpleCurrency(
                                locale: "en_US", name: "TSh", decimalDigits: 2)
                            .format(loans[index].principal)),
                        onTap: () => {
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                LoanDetailsScreen(
                              user: widget.user,
                              loan: loans[index],
                              store: widget.store,
                              company: widget.company,
                            ),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ))
                        },
                      );
//                 }
                    }));
          }),
      // floatingActionButton: FloatingActionButton(
      //     elevation: 0.0,
      //     child: const Icon(Icons.add),
      //     // backgroundColor: new Color(0xFFE57373),
      //     onPressed: () {
      //       Navigator.of(context).pushReplacement(PageRouteBuilder(
      //         pageBuilder: (context, animation1, animation2) =>
      //             NewMemberScreen(
      //           user: widget.user,
      //           store: widget.store,
      //           company: widget.company,
      //         ),
      //         transitionDuration: Duration.zero,
      //         reverseTransitionDuration: Duration.zero,
      //       ));
      //     })
    );
  }
}

String members = """
  query getLoans(\$offset: Int!, \$limit: Int!, \$company_id: Int!) {
    getLoans(offset: \$offset, limit: \$limit, company_id: \$company_id) {
      page_info {
        limit,
        offset,
        total,
        sort,
      },
      entries {
        id,
        principal,
        loan_status,
        period_days,
        credit_status,
        customer {
          id,
          full_name,
          credit_score
        }
      }
    }
  }
""";
