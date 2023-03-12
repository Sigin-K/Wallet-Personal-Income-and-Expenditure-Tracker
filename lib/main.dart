import 'package:flutter/material.dart';
import 'package:Wallet/pages/homepage.dart';
import 'package:Wallet/pages/main_name.dart';
import 'package:Wallet/pages/splash.dart';
import 'package:Wallet/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("money"); //local db to store transactions
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Wallet',
      theme: myTheme,
      home: const Splash(),
    );
  }
}

