import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/config/storage.dart';
import 'package:greece/model/jwt.dart';
import 'package:greece/screen/login.dart';
import 'package:greece/screen/verify_otp.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen() : super();
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  var focusNode = FocusNode();
  String fullNameError = "";
  String companyNameError = "";
  String emailError = "";
  String phoneError = "";
  bool isLoading = false;

  final String signupGqlQuery = """
  mutation signup(\$signupInput: SignupInput!) {
    signup(signupInput: \$signupInput) {
      access_token,
      refresh_token
    }
  }
  """;

  final String meGqlQuery = """
  query me() {
    me() {
      id,
      full_name,
      phone,
      email,
      user_type {
        id,
        name
      },
      store {
        id,
        name,
        phone
      }
    }
  }
""";

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  Future signup(BuildContext context) async {
    String fullName = fullNameController.text.trim();
    if (fullName.isEmpty) {
      setState(() {
        fullNameError = "Invalid full name";
      });
      return;
    } else {
      setState(() {
        fullNameError = "";
      });
    }

    String companyName = companyNameController.text.trim();
    if (companyName.isEmpty) {
      setState(() {
        companyNameError = "Invalid company name";
      });
      return;
    } else {
      setState(() {
        companyNameError = "";
      });
    }

    String email = emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        emailError = "Invalid email";
      });
      return;
    } else {
      setState(() {
        emailError = "";
      });
    }

    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        phoneError = "Invalid phone number";
      });
      return;
    } else {
      setState(() {
        phoneError = "";
      });
    }

    setState(() {
      isLoading = true;
    });
    Jwt token;
    QueryResult result = await GraphQL.client.mutate(MutationOptions(
      document: gql(signupGqlQuery),
      variables: {
        'signupInput': {
          'phone': "+255${phoneController.text}",
          'email': emailController.text,
          'company_name': companyNameController.text,
          'full_name': fullNameController.text,
        }
      },
    ));

    if (result.data == null) {
      await JumpStorage.storage.deleteAll();
      return;
    }

    token = Jwt.fromJson(result.data?['signup']);
    await JumpStorage.storage
        .write(key: 'access_token', value: token.accessToken);
    await JumpStorage.storage
        .write(key: 'refresh_token', value: token.refreshToken);

    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => VerifyOtpScreen(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff4285f4),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/jump_splash.png"),
                  Container(
                    child: TextField(
                      focusNode: focusNode,
                      // keyboardType: TextInputType.phone,
                      controller: fullNameController,
                      textInputAction:
                          TextInputAction.next, // Moves focus to next.

                      decoration: InputDecoration(
                          errorText:
                              fullNameError.isNotEmpty ? fullNameError : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          hintText: "Full name",
                          // suffixText: 'USD',
                          suffixStyle: const TextStyle(color: Colors.white)),
                    ),
                    // margin: const EdgeInsets.only(top: 10.0),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: TextField(
                      controller: companyNameController,
                      textInputAction:
                          TextInputAction.next, // Moves focus to next.
                      decoration: InputDecoration(
                          errorText: companyNameError.isNotEmpty
                              ? fullNameError
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          // hintText: 'Full name',
                          // helperText: 'Keep it short, this is just a demo.',
                          // labelText: 'Phone',
                          hintText: "Company name",
                          // suffixText: 'USD',
                          suffixStyle: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textInputAction:
                          TextInputAction.next, // Moves focus to next.

                      decoration: InputDecoration(
                          errorText:
                              emailError.isNotEmpty ? fullNameError : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white)),
                          hintText: "Email",
                          // suffixText: 'USD',
                          suffixStyle: const TextStyle(color: Colors.white)),
                    ),
                    margin: const EdgeInsets.only(top: 10.0),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      textInputAction:
                          TextInputAction.next, // Moves focus to next.

                      decoration: InputDecoration(
                          errorText:
                              phoneError.isNotEmpty ? fullNameError : null,
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
                  ),
                  Container(
                    child: InkWell(
                      onTap: () => {signup(context)},
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
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
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
                            MaterialPageRoute(builder: (_) => LoginScreen()),
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
                            'Login',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
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
            )));
  }
}
