import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'Foodinfo.dart';
import 'dart:convert';

Map globalselectedboxitems = {"": ""};
final edittoggle = StateNotifierProvider((ref) => ListNotifier(false));

class ListNotifier extends StateNotifier<bool> {
  ListNotifier(bool toggle) : super(false);
  void changemode() {
    state = !state;
  }
}

final editreceipt = StateNotifierProvider((ref) => ReceiptEdit(false));

class ReceiptEdit extends StateNotifier<bool> {
  ReceiptEdit(bool toggle) : super(false);
  void setbool() {
    state = !state;
  }
}

final changenotifierprovider =
    ChangeNotifierProvider<ChangeCount>((ref) => ChangeCount());

class ChangeCount extends ChangeNotifier {
  List<Food> selecteditems = [];
  List<String> addeditems = [];
  int itemcount = 0;
  double totalprice = 0;
  Map checkboxitems = {"": ""};
  var box = Hive.box("Food");
  var user = Hive.box("Accounts");
  bool showdeletebutton = false;
  String searchedword = "";
  bool edittoggle = false;
  bool receiptedit = false;
  void addcount(
      int index, String name, String type, double price, String foodtype) {
    // var box = Hive.box("Food");
    itemcount = box.get(foodtype)[index]["Count"] + 1;
    box.get(foodtype)[index]["Count"] = itemcount;
    if (addeditems.contains("$index $name")) {
      selecteditems[addeditems.indexOf("$index $name")].count =
          box.get(foodtype)[index]["Count"];
      selecteditems[addeditems.indexOf("$index $name")].total =
          itemcount * price;
      totalprice += price;
    } else {
      totalprice += price;
      selecteditems = [
        ...selecteditems,
        Food(name, type, price, itemcount, price)
      ];
      addeditems.add("$index $name");
    }
    notifyListeners();
  }

  void toggleedit() {
    edittoggle = !edittoggle;
    notifyListeners();
  }

  void recipteditswitch() {
    receiptedit = !receiptedit;
    notifyListeners();
  }

  void subcount(int index, String foodtype, String name) {
    itemcount = box.get(foodtype)[index]["Count"];
    if (itemcount == 0) {
      if (addeditems.contains(index)) {
        addeditems.remove(index);
      }
    } else if (itemcount - 1 == 0) {
      itemcount = box.get(foodtype)[index]["Count"] - 1;
      box.get(foodtype)[index]["Count"] = itemcount;
      selecteditems[addeditems.indexOf("$index $name")].count = itemcount;
      selecteditems.remove(selecteditems[addeditems.indexOf("$index $name")]);
      addeditems.remove("$index $name");
      totalprice -= double.parse(box.get(foodtype)[index]["Price"].toString());
      totalprice = 0.0;
      notifyListeners();
    } else {
      itemcount = box.get(foodtype)[index]["Count"] - 1;

      box.get(foodtype)[index]["Count"] = itemcount;
      selecteditems[addeditems.indexOf("$index $name")].count = itemcount;
      selecteditems[addeditems.indexOf("$index $name")].total -=
          selecteditems[addeditems.indexOf("$index $name")].price;
      totalprice -= double.parse(box.get(foodtype)[index]["Price"].toString());
      notifyListeners();
    }
  }

  void additem(Map iteminfo) {
    Map tempcontainer = iteminfo;

    if (tempcontainer.containsValue(null)) {
    } else {
      String type = tempcontainer["Type"];
      List parenttype = utf8.encode(type);
      if (box.containsKey(parenttype.toString())) {
        List listcontainer = List.from(box.get(parenttype.toString()));
        listcontainer.add(tempcontainer);
        box.put(parenttype.toString(), listcontainer);
      } else {
        List listcontainer = [tempcontainer];
        box.put(parenttype.toString(), listcontainer);
      }
    }
    notifyListeners();
  }

  void removeitems() async {
    checkboxitems.keys.forEach((element) async {
      if (element == " ") {
      } else {
        var tempcontainer = utf8.encode(element.split(",")[1]);
        List firstcont = List.from(box.get(tempcontainer.toString()));
        firstcont[int.parse(element.split(",")[0])] = " ";
        await box.put(tempcontainer.toString(), firstcont);
      }
    });
    box.keys.forEach((element) {
      List secondcont = List.from(box.get(element));
      secondcont.removeWhere((item) => item == " ");
      box.put(element, secondcont);
    });
    checkboxitems = {" ": " "};
    checkboxitems.clear();
    notifyListeners();
  }

  void selecteditemslist(int index, String foodtype) {
    String container = "$index" + "," + foodtype;
    if (checkboxitems.containsKey(container)) {
      checkboxitems.remove(container);
      if (checkboxitems.containsValue(true) == false) {
        showdeletebutton = false;
      }
    } else {
      checkboxitems[container] = true;
      showdeletebutton = true;
    }
    notifyListeners();
  }

  void clearselecteditems() {
    checkboxitems.clear();
    showdeletebutton = false;
    checkboxitems = {" ": " "};
    notifyListeners();
  }

  void clearcart() {
    box.keys.forEach((element) {
      box.get(element).forEach((index) {
        index["Count"] = 0;
      });
    });
    selecteditems.clear();
    addeditems.clear();
    notifyListeners();
    totalprice = 0;
  }

  void removelist(String foodtype) {
    List parenttype = utf8.encode(foodtype);
    box.delete(parenttype.toString());
    notifyListeners();
  }

  void changetype(String newfoodtype, String foodtype) {
    if (newfoodtype == foodtype) {
      print("here");
    } else {
      checkboxitems.keys.forEach((element) async {
        if (element == " ") {
        } else {
          List secondcont = List.from(box.get(newfoodtype));
          print(box.get(foodtype)[int.parse(element.split(",")[0])]);
          secondcont.add(box.get(foodtype)[int.parse(element.split(",")[0])]);
          box.put(newfoodtype, secondcont);
          print("here");
          List firstcont = List.from(box.get(foodtype));
          firstcont[int.parse(element.split(",")[0])] = " ";
          box.put(foodtype, firstcont);
          print("there");
        }
      });
      box.keys.forEach((element) async {
        List altcont = List.from(box.get(element));
        altcont.removeWhere((item) => item == " ");
        await box.put(element, altcont);
      });
    }
    checkboxitems = {" ": " "};
    checkboxitems.clear();
    notifyListeners();
  }

  void adjustreceipt(double value, int index) {
    totalprice -= selecteditems[index].total;
    selecteditems[index].total = value;
    totalprice += value;
    print(totalprice);
    notifyListeners();
  }
}
