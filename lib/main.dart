import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:save_it/src/routes/homepage.dart';
import 'package:save_it/src/database/db.dart';
import 'package:save_it/src/routes/first_run.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('name') ?? 'NA';
  await DB.init();

  runApp(MaterialApp(
    title: 'Save It',
    home: name == 'NA' ? FirstRun(prefs) : HomePage(prefs),
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
  ));
}
