import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/user.dart';
import 'package:greece/screen/companies.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/login.dart';
import 'package:greece/screen/stores.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final String meString = """
  query me() {
    me() {
      id,
      full_name,
      user_type,
      account {
        id,
        phone
      },
      company {
        id,
        name,
      }
    }
  }
""";

  late User me;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Query(
            options: QueryOptions(
              document: gql(meString),
            ),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              //atrocious

              if (result.isLoading && result.data == null) {
                // return Container(
                //     color: Color(0xff4285f4),
                //     child: Image.asset(
                //       "assets/images/jump_splash.png",
                //       fit: BoxFit.cover,
                //       // height: double.infinity,
                //       // width: 100,
                //     ));
                return Container(
                  color: const Color(0xff4285f4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('assets/images/jump_splash.png'),
                        fit: BoxFit.cover,
                        height: 300,
                        // width: double.infinity,
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                );
              }

              if (result.hasException || result.data == null) {
                JumpStorage.storage.deleteAll();
                scheduleMicrotask(() => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen())));
                ;
              } else {
                me = User.fromJson(result.data?["me"] as Map<String, dynamic>);
                processUser(me, context);
              }

              return Container(
                color: const Color(0xff4285f4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage('assets/images/jump_splash.png'),
                      fit: BoxFit.cover,
                      height: 300,
                      // width: double.infinity,
                      alignment: Alignment.center,
                    )
                  ],
                ),
              );
            }));
  }

  updateUserDetails(String? token) async {
    QueryResult result = await GraphQL.client.mutate(MutationOptions(
      document: gql(UPDATE_USER_DETAILS),
      variables: {
        'updateUserInput': {
          'id': me.id,
          'fcm_token': token,
        }
      },
    ));

    if (result.data == null) {
      return;
    }
  }

  // Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //   await Firebase.initializeApp();

  //   print("Handling a background message: ${message.messageId}");
  // }

  String UPDATE_USER_DETAILS = """
    mutation updateUser(\$updateUserInput: UpdateUserInput!) {
      updateUser(updateUserInput: \$updateUserInput) {
          id
        }
      }
  """;

  // fcm(User user) async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  //   final fcm = FirebaseMessaging.instance;
  //   final String? fcmToken = await fcm.getToken();
  //   updateUserDetails(fcmToken);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('Got a message whilst in the foreground!');
  //     print('Message data: ${message.data}');

  //     if (message.notification != null) {
  //       print('Message also contained a notification: ${message.notification}');
  //     }
  //   });

  //   FirebaseMessaging.instance.onTokenRefresh.listen(updateUserDetails);

  //   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }

  processUser(User user, BuildContext context) async {
    // fcm(user);
    // Create storage
    final storage = FlutterSecureStorage();

    // Write value=
    await storage.write(key: "me", value: me.toString());

    // // Read value
    // String value = await storage.read(key: key);

    if (user.company?.companyType?.name == 'Distributor') {
      // Navigator.of(context).pushReplacement(PageRouteBuilder(
      //   pageBuilder: (context, animation1, animation2) =>
      //       CompaniesScreen(user: user, store: user.store),
      //   transitionDuration: Duration.zero,
      //   reverseTransitionDuration: Duration.zero,
      // ));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            HomeScreen(user: user, store: user.store, company: user.company),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    }
  }
}
