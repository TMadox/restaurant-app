import 'package:desktop_food/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hive/hive.dart';
import 'package:get/get.dart';

class SignUpUi extends HookWidget {
  GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();
  Widget build(BuildContext context) {
    Map signupinfo = {
      "Username": null,
      "Password": null,
      "Passwordrepeat": null
    };
    var usersignup = Hive.box("Accounts");
    return GetMaterialApp(
        key: UniqueKey(),
        navigatorKey: navKey,
        textDirection: TextDirection.ltr,
        home: Scaffold(
          body: Container(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  color: Colors.blue,
                ),
                Container(
                  height: 350,
                  width: 400,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "ادخل كلمة مستخدم جديدة",
                          ),
                          onChanged: (value) {
                            signupinfo["Username"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "ادخل كلمة سر جديدة",
                          ),
                          onChanged: (value) {
                            signupinfo["Password"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "كرر كلمة السر ",
                          ),
                          onChanged: (value) {
                            signupinfo["Passwordrepeat"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "يجب ان تكون المدخلات باللغة الانجليزية",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (signupinfo.containsValue(null)) {
                                  print("nope");
                                } else if (signupinfo["Password"] !=
                                    signupinfo["Passwordrepeat"]) {
                                  print("nope again");
                                } else {
                                  print("done");
                                  usersignup.put(signupinfo["Username"],
                                      signupinfo["Password"]);
                                }
                              },
                              child: Text(
                                "تسجيل ",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                Get.to(() => LoginUi());
                              },
                              child: Text(
                                "دخول",
                                textAlign: TextAlign.center,
                              )),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
