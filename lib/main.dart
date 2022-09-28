import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greece/config/grapqhl.dart';
import 'package:greece/screen/auth.dart';

void main() async {
  // This widget is the root of your application.

  // this is needed to support lower version of android
  //otherwise it's going to give CERT_INVALID
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: ValueNotifier(GraphQL.client),
        child: CacheProvider(
            child: MaterialApp(
                title: 'Jump',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primaryColor: Color(0xFF2661FA),
                  scaffoldBackgroundColor: Colors.white,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: AuthScreen())));
  }
}
