import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/jwt.dart';
import 'package:greece/screen/signup.dart';
import 'package:greece/screen/verify_otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // String username = "tommaso.girotto91@gmail.com";
  // String password = "Kamhlaba91!";
  bool isLoading = false;
  String error = "";
  var focusNode = FocusNode();

  TextEditingController phoneController = new TextEditingController();

  final String phoneLoginGql = """
  mutation phoneLogin(\$phoneLoginInput: PhoneLoginInput!) {
    phoneLogin(phoneLoginInput: \$phoneLoginInput) {
      access_token,
      refresh_token
    }
  }
  """;

  final String storesGql = """
  query stores() {
    stores() {
      id,
      name
    }
  }
""";

  final String meGql = """
  query me() {
    me() {
      id,
      full_name,
      phone,
      email,
      company {
        id,
        name
      },
      user_type {
        id,
        name
      },
      store {
        id,
        name,
        phone,
        address
      }
    }
  }
""";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneController.dispose();
    super.dispose();
  }

  @override
  initState() {
    isLoading = false;
    error = "";
    super.initState();
  }

  Future login(BuildContext context) async {
    if (isLoading) {
      return;
    }

    String phone = phoneController.text.trim();
    if (phone.length < 1) {
      setState(() {
        error = "Invalid phone number";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    Jwt token;
    QueryResult result = await GraphQL.client.mutate(MutationOptions(
      document: gql(phoneLoginGql),
      variables: {
        'phoneLoginInput': {
          'phone': "+255${phoneController.text}",
        }
      },
    ));

    if (result.data == null) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(result.exception.toString())));

      setState(() {
        isLoading = false;
        error = "Invalid number";
      });
      await JumpStorage.storage.deleteAll();
      setState(() {
        isLoading = false;
        error = "Invalid number";
      });
      return;
    }

    // token = AccessToken.fromJson(result.data?['phoneLogin']);
    // await JumpStorage.storage
    //     .write(key: 'access_token', value: token.access_token);
    // await JumpStorage.storage
    //     .write(key: 'refresh_token', value: token.refresh_token);

    // //need to keep track of when the token was refreshed to make sure that we know when to update it later
    // final now = DateTime.now();
    // await JumpStorage.storage
    //     .write(key: 'refreshed_at', value: now.toIso8601String());

    // QueryResult me = await GraphQL.client.query(QueryOptions(
    //   document: gql(meGql),
    // ));

    // User user = User.fromJson(me.data?['me']);

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => VerifyOtpScreen(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    focusNode.requestFocus();

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20.0),
      color: Color(0xff4285f4),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/jump_splash.png"),
          TextField(
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            controller: phoneController,
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
                hintText: "Phone",
                prefixText: '+255 ',
                // suffixText: 'USD',
                suffixStyle: const TextStyle(color: Colors.white)),
          ),
          Container(
            child: InkWell(
              onTap: () => {login(context)},
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
                    'Login',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            margin: const EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: InkWell(
              onTap: () => {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => SignupScreen()),
                    (route) => false)
              },
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
                    'Signup',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            margin: const EdgeInsets.only(top: 10.0),
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
