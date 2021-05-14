import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('Food');
  var box = await Hive.openBox('Accounts');
  runApp(ProviderScope(child: box.isEmpty ? SignUpUi() : LoginUi()));
}
