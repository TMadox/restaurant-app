import 'package:desktop_food/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'MainScreen.dart';
import 'package:get/get.dart';

class LoginUi extends HookWidget {
  GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();
  Widget build(BuildContext context) {
    Map logininfo = {
      "Username": null,
      "Password": null,
    };
    var userlogin = Hive.box("Accounts");
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
                  height: 200,
                  width: 400,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            logininfo["Username"] = value;
                          },
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "اسم المستخدم",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "كلمة السر",
                          ),
                          onChanged: (value) {
                            logininfo["Password"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () => Get.to(() => SignUpUi()),
                              child: Text(
                                "تسجيل جديد",
                                textAlign: TextAlign.center,
                              )),
                          ElevatedButton(
                              onPressed: () {
                                if (logininfo.containsValue(null)) {
                                  Get.dialog(Center(
                                    child: Container(
                                      height: 200,
                                      width: 400,
                                      color: Colors.white,
                                      child: Center(child: Icon(Icons.warning)),
                                    ),
                                  ));
                                } else if (userlogin
                                        .get(logininfo["Username"]) ==
                                    logininfo["Password"].toString()) {
                                  Get.to(() => MyApp());
                                }
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
