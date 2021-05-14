import 'package:desktop_food/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HIVE.dart';
import 'states.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends HookWidget {
  var box = Hive.box("Food");

  Widget build(BuildContext context) {
    final state = useProvider(changenotifierprovider);
    final toggleedit = useProvider(edittoggle);
    final togglerReceiptedit = useProvider(editreceipt);

    

    return MaterialApp(
      home: DefaultTabController(
        length: box.keys.length,
        child: Scaffold(
          appBar: AppBar(
              actions: [],
              title: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        Get.to(() => LoginUi());
                      })
                ],
              ),
              bottom: TabBar(
                  tabs: box.keys.map((e) {
                List<int> test = json.decode(e).cast<int>();
                String finals = utf8.decode(test);
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                          visible: state.edittoggle,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              state.removelist(finals);
                            },
                          )),
                      Text(
                        finals,
                      ),
                    ],
                  ),
                );
              }).toList())),
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: box.keys.isEmpty
                    ? Maincomp("e")
                    : TabBarView(
                        children: box.keys.map((e) {
                        return Maincomp(e);
                      }).toList()),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue, width: 5),
                    color: Colors.blueAccent,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ListView.builder(
                          itemCount: state.selecteditems.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: state.receiptedit
                                          ? SizedBox(
                                              width: 40,
                                              child: TextField(
                                                onChanged: (value) {},
                                                onSubmitted: (value) {
                                                  state.adjustreceipt(
                                                      double.parse(value),
                                                      index);
                                                },
                                                controller:
                                                    TextEditingController(),
                                                textAlign: TextAlign.end,
                                                textInputAction:
                                                    TextInputAction.done,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue,
                                                          width: 2),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.blue),
                                                    ),
                                                    hoverColor: Colors.blue,
                                                    focusColor:
                                                        Colors.blueAccent,
                                                    fillColor:
                                                        Colors.blueAccent,
                                                    border: InputBorder.none,
                                                    hintText: state
                                                        .selecteditems[index]
                                                        .total
                                                        .toString()),
                                                cursorColor: Colors.blueAccent,
                                              ),
                                            )
                                          : Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text((state
                                                      .selecteditems[index]
                                                      .total)
                                                  .toString()),
                                            ),
                                    ),
                                    Container(
                                      child: Text(state
                                          .selecteditems[index].count
                                          .toString()),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        // color: Colors.blue,
                                        padding: EdgeInsets.only(right: 10),
                                        width: 120,
                                        child: Text(
                                          state.selecteditems[index].name,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white, width: 5),
                              color: Colors.white,
                            ),
                            child: SizedBox(
                              width: 600,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 45, left: 20),
                                  child: Text(
                                    "المجموع الكلي: " +
                                        state.totalprice.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            )),
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              state.recipteditswitch();
                            },
                            child: Text(
                              "تعديل الفاتورة",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white70, // background
                              onPrimary: Colors.black87, // foreground
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              state.clearcart();
                            },
                            child: Text(
                              "مسح الفاتورة",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red, // background
                              onPrimary: Colors.black, // foreground
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Text("شراء"),
            onPressed: () async {
              forcepopulatehive();
              if (state.selecteditems.isEmpty) {
              } else {

              }
            },
          ),
        ),
      ),
    );
  }
}

class Maincomp extends HookWidget {
  String foodtype;
  Map newiteminfo = {"Type": null, "Price": null, "Name": null, "Count": 0};
  var _namecontroller = TextEditingController();
  var _typecontroller = TextEditingController();
  var _pricecontroller = TextEditingController();
  Maincomp(String foo) {
    foodtype = foo;
  }
  var box = Hive.box("Food");
  bool switchmode = false;
  Widget build(BuildContext context) {
    useEffect(() {
      _namecontroller.text = "shit";
      return null;
    }, []);
    final state = useProvider(changenotifierprovider);
    final toggleedit = useProvider(edittoggle);

    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Visibility(
          visible: state.showdeletebutton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    state.clearselecteditems();
                  },
                  child: Text("  مسح العلامات  "),
                ),
              ),
              DropdownButton(
                value: foodtype,
                onChanged: (value) {
                  state.changetype(value.toString(), foodtype);
                },
                items: box.keys.map((e) {
                  List<int> test = json.decode(e).cast<int>();
                  String finals = utf8.decode(test);
                  return DropdownMenuItem(
                    child: Text(finals),
                    value: e,
                  );
                }).toList(),
              ),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.black, // foreground
                  ),
                  onPressed: () {
                    state.removeitems();
                  },
                  child: Text("  مسح الاصناف المختارة   "),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: box.keys.isEmpty
              ? Text(
                  "...القائمة فارغ",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.get(foodtype).length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Card(
                          child: Container(
                              height: Get.height * 0.07,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                      visible: state.edittoggle,
                                      child: Checkbox(
                                          value: state.checkboxitems["$index" +
                                                      "," +
                                                      box.get(foodtype)[index]
                                                          ["Type"]] ==
                                                  null
                                              ? false
                                              : true,
                                          onChanged: (bool value) {
                                            state.selecteditemslist(
                                                index,
                                                box.get(foodtype)[index]
                                                    ["Type"]);
                                          })),
                                  Container(
                                      child: state.edittoggle
                                          ? SizedBox(
                                              width: 100,
                                              child: TextField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                onChanged: (value) {},
                                                controller:
                                                    TextEditingController()
                                                      ..text = box
                                                          .get(foodtype)[index]
                                                              ["Price"]
                                                          .toString(),
                                                onSubmitted: (value) {
                                                  List secondcont = List.from(
                                                      box.get(foodtype));
                                                  secondcont[index]["Price"] =
                                                      value;
                                                  box.put(foodtype, secondcont);
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blue,
                                                        width: 2),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blue),
                                                  ),
                                                  hoverColor: Colors.blue,
                                                  focusColor: Colors.blueAccent,
                                                  fillColor: Colors.blueAccent,
                                                  border: InputBorder.none,
                                                ),
                                                cursorColor: Colors.blueAccent,
                                              ),
                                            )
                                          : Text(
                                              box
                                                  .get(foodtype)[index]["Price"]
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                            )),
                                  Flexible(child: SizedBox(width: 300)),
                                  Visibility(
                                    visible: state.edittoggle ? false : true,
                                    child: Expanded(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                state.subcount(
                                                    index,
                                                    foodtype,
                                                    box.get(foodtype)[index]
                                                        ["Name"]);
                                              },
                                            ),
                                          ),
                                          Flexible(
                                              child: Text(box
                                                  .get(foodtype)[index]["Count"]
                                                  .toString())),
                                          Flexible(
                                            child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                state.addcount(
                                                    index,
                                                    box.get(foodtype)[index]
                                                        ["Name"],
                                                    box.get(foodtype)[index]
                                                        ["Type"],
                                                    double.parse(box
                                                        .get(foodtype)[index]
                                                            ["Price"]
                                                        .toString()),
                                                    foodtype);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  state.edittoggle
                                      ? Expanded(
                                          child: TextField(
                                            onChanged: (value) {},
                                            controller: TextEditingController()
                                              ..text = box
                                                  .get(foodtype)[index]["Name"]
                                                  .toString(),
                                            onSubmitted: (value) {
                                              List secondcont =
                                                  List.from(box.get(foodtype));
                                              secondcont[index]["Name"] = value;
                                              box.put(foodtype, secondcont);
                                            },
                                            textAlign: TextAlign.end,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blue),
                                                ),
                                                hoverColor: Colors.blue,
                                                focusColor: Colors.blueAccent,
                                                fillColor: Colors.blueAccent,
                                                border: InputBorder.none,
                                                hintText: 'اسم الصنف'),
                                            cursorColor: Colors.blueAccent,
                                          ),
                                        )
                                      : Flexible(
                                          child: SizedBox(
                                            width: 150,
                                            child: Text(
                                              box
                                                  .get(foodtype)[index]["Name"]
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ),
                                ],
                              ))),
                    );
                  },
                ),
        ),
        Divider(
          color: Colors.blue,
          thickness: 2,
          indent: 100,
          endIndent: 100,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              state.toggleedit();
              state.clearselecteditems();
              state.clearcart();
            },
            child: Text("تعديل القائمة"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Visibility(
            visible: state.edittoggle,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue, width: 5),
                color: Colors.white,
              ),
              child: Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  SizedBox(
                      width: 200,
                      height: 50,
                      child: TextField(
                        onChanged: (value) {
                          newiteminfo["Price"] = value;
                        },
                        controller: _pricecontroller,
                        onSubmitted: (value) {},
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hoverColor: Colors.blue,
                            focusColor: Colors.blueAccent,
                            fillColor: Colors.blueAccent,
                            border: InputBorder.none,
                            hintText: 'سعر الصنف'),
                        cursorColor: Colors.blueAccent,
                      )),
                  SizedBox(
                      width: 200,
                      height: 50,
                      child: TextField(
                        controller: _typecontroller,
                        onChanged: (value) {
                          newiteminfo["Type"] = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          hoverColor: Colors.blue,
                          focusColor: Colors.blueAccent,
                          fillColor: Colors.blueAccent,
                          border: InputBorder.none,
                          hintText: 'نوع الصنف',
                        ),
                        cursorColor: Colors.blueAccent,
                      )),
                  SizedBox(
                      width: 200,
                      height: 50,
                      child: TextField(
                        controller: _namecontroller,
                        onChanged: (value) {
                          newiteminfo["Name"] = value;
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hoverColor: Colors.blue,
                            focusColor: Colors.blueAccent,
                            fillColor: Colors.blueAccent,
                            border: InputBorder.none,
                            hintText: 'اسم الصنف'),
                        cursorColor: Colors.blueAccent,
                      )),
                  SizedBox(
                    child: ElevatedButton(
                        onPressed: () {
                          state.additem(newiteminfo);
                          _namecontroller.clear();
                          _pricecontroller.clear();
                          _typecontroller.clear();
                        },
                        child: Text("اضافة")),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                ],
              )),
            ))
      ],
    );
  }
}
