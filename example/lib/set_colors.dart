import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:smartech_flutter_plugin/smt_notification_options.dart';

import 'main.dart';

class SetIconColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Icon Colors"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  var option = SMTNotificationOptions(
                      transparentIconBgColor: "#ffff0000");
                  SmartechPlugin().setNotificationOptions(option);
                  var _shp = await SharedPreferences.getInstance();
                  _shp.setString("color", "ffff0000");
                  showTost("Notification icon set to red");
                },
                child: Text("Red")),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var option =
                    SMTNotificationOptions(transparentIconBgColor: "#ff0000ff");
                SmartechPlugin().setNotificationOptions(option);
                var _shp = await SharedPreferences.getInstance();
                _shp.setString("color", "ff0000ff");
                showTost("Notification icon set to blue");
              },
              child: Text("Blue")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var option =
                    SMTNotificationOptions(transparentIconBgColor: "#ff800080");
                SmartechPlugin().setNotificationOptions(option);
                var _shp = await SharedPreferences.getInstance();
                _shp.setString("color", "ff800080");
                showTost("Notification icon set to purple");
              },
              child: Text("Purple")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var option =
                    SMTNotificationOptions(transparentIconBgColor: "#ff888888");
                SmartechPlugin().setNotificationOptions(option);
                var _shp = await SharedPreferences.getInstance();

                _shp.setString("color", "ff888888");
              },
              child: Text("Reset notification icon color")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                var _shp = await SharedPreferences.getInstance();
                showTost("Notification icon color: ${_shp.get("color")}");
              },
              child: Text("Get push icon color")),
        ],
      ),
    );
  }
}

showTost(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 13.0);
}
