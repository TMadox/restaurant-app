import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future populatehive() async {
  var box = Hive.box("Food");
  if (box.isEmpty) {
    print("fuck");
    String jsonString = await rootBundle.loadString("assets/New Menu.json");
    Map tempmenu = await jsonDecode(jsonString);
    tempmenu.forEach((key, value) {
      String arabicword = key;
      var tempcontainer = utf8.encode(arabicword);
      print(tempcontainer);
      box.put(tempcontainer.toString(), value);
    });
    return box;
  } else {
    return box;
  }
}

Future forcepopulatehive() async {
  var box = Hive.box("Food");
  box.clear();
  String jsonString = await rootBundle.loadString("assets/New Menu.json");
  Map tempmenu = await jsonDecode(jsonString);
  tempmenu.forEach((key, value) {
    String arabicword = key;
    var tempcontainer = utf8.encode(arabicword);
    box.put(tempcontainer.toString(), value);
  });
}
