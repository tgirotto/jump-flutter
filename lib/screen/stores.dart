// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:greece/model/edge.dart';
// import 'package:greece/model/page.dart' as p;
// import 'package:greece/model/store.dart' as s;
// import 'package:greece/model/company.dart' as c;
// import 'package:greece/model/user.dart';
// import 'package:greece/screen/companies.dart';
// import 'package:greece/screen/home.dart';
// import 'package:greece/screen/settings.dart';
// import 'package:greece/screen/store_new.dart';

// class StoresScreen extends StatefulWidget {
//   User user;
//   final s.Store? store;
//   final c.Company company;
//   StoresScreen(
//       {super.key, required this.user, this.store, required this.company});
//   @override
//   StoresScreenState createState() => StoresScreenState();
// }

// class StoresScreenState extends State<StoresScreen> {
//   final pageSize = 20;
//   late p.Page<s.Store> page;
//   late FetchMoreOptions opts;
//   late QueryResult result;
//   late List<s.Store> stores = [];
//   late FetchMore? fetchMore;

//   ScrollController scrollController = ScrollController();

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//             title: Text(widget.company.name,
//                 style: const TextStyle(color: Colors.white)),
//             // leading: (widget.user.company.companyType?.name == 'Distributor')
//             //     ? IconButton(
//             //         icon: const Icon(Icons.arrow_back),
//             //         onPressed: () => {
//             //           Navigator.of(context).pushReplacement(PageRouteBuilder(
//             //             pageBuilder: (context, animation1, animation2) =>
//             //                 CompaniesScreen(
//             //               user: widget.user,
//             //               store: widget.store,
//             //             ),
//             //             transitionDuration: Duration.zero,
//             //             reverseTransitionDuration: Duration.zero,
//             //           ))
//             //         },
//             //       )
//             //     : null,
//             automaticallyImplyLeading: false,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.account_circle),
//                 tooltip: 'Show Snackbar',
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => SettingScreen(
//                             user: widget.user, store: widget.store)),
//                   );
//                 },
//               ),
//             ]),
//         body: Query(
//             options: QueryOptions(
//               document: gql(GET_STORES),
//               variables: {
//                 'first': pageSize,
//                 'after': "",
//                 'company': {"id": widget.company.id}
//               },
//             ),
//             builder: (QueryResult result,
//                 {VoidCallback? refetch, FetchMore? fetchMore}) {
//               if (result.isLoading && result.data == null) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               if (result.hasException) {
//                 return const Text('\nErrors: \n  ');
//               }

//               if (result.data == null) {
//                 return const Text(
//                     'Both data and errors are null, this is a known bug after refactoring, you might forget to set Github token');
//               }

//               page = p.Page<s.Store>.fromJson(
//                   result.data?['getStores']['page'], s.Store.fromJson);

//               stores = page.entries.map((Entry<s.Store> e) => e.node).toList();

//               // final Map pageInfo = result.data['search']['pageInfo'];
//               String? fetchMoreCursor = page.pageInfo.endCursor;

//               FetchMoreOptions opts = FetchMoreOptions(
//                 variables: {
//                   'after': fetchMoreCursor,
//                   'first': pageSize,
//                   'company': {"id": widget?.company?.id}
//                 },
//                 updateQuery: (previousResultData, fetchMoreResultData) {
//                   // this is where you combine your previous data and response
//                   // in this case, we want to display previous repos plus next repos
//                   // so, we combine data in both into a single list of repos
//                   final List<dynamic> repos = [
//                     ...previousResultData?['getStores']['page']['edges']
//                         as List<dynamic>,
//                     ...fetchMoreResultData?['getStores']['page']['edges']
//                         as List<dynamic>
//                   ];

//                   fetchMoreResultData?['getStores']['page']['edges'] = repos;

//                   return fetchMoreResultData;
//                 },
//               );

//               if (stores.isEmpty) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Image.asset("assets/images/searching.png",
//                         width: size.width, height: 200),
//                     const Text("No stores found")
//                   ],
//                 );
//               } else {
//                 return NotificationListener(
//                   onNotification: (dynamic t) {
//                     if (t is ScrollEndNotification &&
//                         scrollController.position.pixels >=
//                             scrollController.position.maxScrollExtent * 0.9 &&
//                         page.pageInfo.hasNextPage &&
//                         !result.isLoading) {
//                       fetchMore!(opts);
//                     }
//                     return true;
//                   },
//                   child: ListView.builder(
//                       controller: scrollController,
//                       itemCount: stores.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return ListTile(
//                           leading: Container(
//                             width: 50.0,
//                             height: 50.0,
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Container(
//                               alignment: Alignment.center,
//                               child: Text(stores[index].name[0].toUpperCase(),
//                                   style: const TextStyle(
//                                       fontSize: 20, color: Colors.white)),
//                             ),
//                           ),
//                           title: Text(stores[index].name),
//                           // trailing: const Icon(Icons.add),
//                           onTap: () => {
//                             Navigator.of(context)
//                                 .pushReplacement(PageRouteBuilder(
//                               pageBuilder: (context, animation1, animation2) =>
//                                   HomeScreen(
//                                       user: widget.user,
//                                       company: widget.company,
//                                       store: stores[index]),
//                               transitionDuration: Duration.zero,
//                               reverseTransitionDuration: Duration.zero,
//                             ))
//                           },
//                         );
//                       }),
//                 );
//               }
//             }),
//         floatingActionButton: FloatingActionButton(
//             elevation: 0.0,
//             child: const Icon(Icons.add),
//             // backgroundColor: new Color(0xFFE57373),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => NewStoreScreen(
//                             user: widget.user,
//                             company: widget.company,
//                           )));
//             }));
//   }
// }

// String GET_STORES = """
//   query getStores(\$first: Float!, \$after: String!, \$company: MapCompanyInput) {
//     getStores(first: \$first, after: \$after, company: \$company) {
//         page {
//           pageInfo {
//             startCursor,
//             endCursor,
//             hasNextPage
//           },
//           edges {
//             cursor
//             node {
//               id,
//               name,
//               phone,
//               address,
//               phone,
//               store_type {
//                 id,
//                 name
//               },
//               store_categories {
//                 id,
//                 name
//               }
//             }
//           }
//       }
//     }
//   }
// """;
