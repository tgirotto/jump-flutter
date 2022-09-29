import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/jwt.dart';
import 'package:greece/model/user.dart';
import 'package:greece/model/store.dart' as s;
import 'package:greece/screen/companies.dart';
import 'package:greece/screen/home.dart';
import 'package:greece/screen/stores.dart';

class VerifyOtpScreen extends StatefulWidget {
  VerifyOtpScreen() : super();
  @override
  VerifyScreenState createState() => VerifyScreenState();
}

class VerifyScreenState extends State<VerifyOtpScreen> {
  // String username = "tommaso.girotto91@gmail.com";
  // String password = "Kamhlaba91!";
  late QueryResult result = QueryResult.unexecuted;
  TextEditingController otpController = new TextEditingController();
  var focusNode = FocusNode();
  var emptyfocusNode = FocusNode();
  bool isLoading = false;
  String error = "";
  late User me;
  final String otpGql = """
  mutation verifyToken(\$token: String!) {
    verifyToken(token: \$token) {
      access_token,
      refresh_token
    }
  }
  """;

  final String meGql = """
  query me() {
    me() {
      id,
      full_name,
      account {
        id
      },
      company {
        id,
        name
      }
    }
  }
""";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    otpController.dispose();

    super.dispose();
  }

  Future verifyOtp(BuildContext context) async {
    String otp = otpController.text.trim();
    if (otp.length < 1) {
      setState(() {
        error = "Invalid code";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    result = await GraphQL.client.mutate(MutationOptions(
      document: gql(otpGql),
      variables: {'token': otpController.text},
    ));

    if (result.hasException || result.data == null) {
      setState(() {
        isLoading = false;
        error = "Invalid code";
      });
      return;
    }

    Jwt token = Jwt.fromJson(result.data?['verifyToken']);
    await JumpStorage.storage
        .write(key: 'access_token', value: token.accessToken);
    await JumpStorage.storage
        .write(key: 'refresh_token', value: token.refreshToken);

    //need to keep track of when the token was refreshed to make sure that we know when to update it later
    final now = DateTime.now();
    await JumpStorage.storage
        .write(key: 'refreshed_at', value: now.toIso8601String());

    QueryResult meQueryResult = await GraphQL.client.query(QueryOptions(
      document: gql(meGql),
    ));

    me = User.fromJson(meQueryResult.data?['me']);
    // FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());

    // fcm(me);
    if (me.company?.companyType?.name == 'Distributor') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CompaniesScreen(user: me, store: me.store)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              HomeScreen(company: me.company, user: me, store: me.store)));
    }
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // focusNode.requestFocus();

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20.0),
      color: Color(0xff4285f4),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/otp.png", width: size.width, height: 200),
          TextField(
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            controller: otpController,
            textInputAction: TextInputAction.next, // Moves focus to next.

            decoration: InputDecoration(
                errorText: error.length > 0 ? error : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.white)),
                // hintText: 'Full name',
                // helperText: 'Keep it short, this is just a demo.',
                // labelText: 'Phone',
                hintText: "Code",
                // prefixText: '+255 ',
                // suffixText: 'USD',
                suffixStyle: const TextStyle(color: Colors.white)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: InkWell(
              onTap: () => {verifyOtp(context)},
              child: Container(
                //width: 100.0,
                height: 50.0,
                decoration: BoxDecoration(
                  // back,
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Center(
                  child: Text(
                    'Verify',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text(""),
          )
        ],
      ),
    ));
  }
}
