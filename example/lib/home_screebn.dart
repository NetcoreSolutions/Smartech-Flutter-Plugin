import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartech_flutter_plugin/SMTNotificationMessageType.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:smartech_flutter_plugin/smt_notification_options.dart';

import 'custom_event.dart';
import 'login_screen.dart';
import 'main.dart';
import 'set_colors.dart';
import 'track_event.dart';
import 'update_profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  SliverGridDelegate? gridDelegate;
  String? platformVersion = "Unkown";
  @override
  void initState() {
    super.initState();
    getPlateform();
    WidgetsBinding.instance?.addObserver(this);
    SmartechPlugin().onhandleDeeplinkActionBackground();
  }

  getPlateform() async {
    platformVersion = await SmartechPlugin().platformVersion;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().logoutAndClearUserIdentity(true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (builder) => LoginScreen()));
                      },
                      child: Text("LOGOUT AND CLEAR USER IDENTITY"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        launchURL("http://www.google.com");
                        // SmartechPlugin().clearUserIdentity();
                      },
                      child: Text("CLEAR USER IDENTITY"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => UpdateProfile()));
                      },
                      child: Text("UPDATE USER PROFILE"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text("HANDLE PUSH NOTIFICATION"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => TarckEventScreen()));
                      },
                      child: Text("TRACK EVENT"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().setUserLocation(21.089721, 79.068722);
                      },
                      child: Text("SET USER LOCATION"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().optPushNotification(false);
                      },
                      child: Text("OPT-OUT PUSH NOTIFICATION"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        var value =
                            await SmartechPlugin().hasOptedPushNotification();

                        Fluttertoast.showToast(
                            msg: value.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 13.0);
                      },
                      child: Text("GET OPT-OUT STATUS"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        SmartechPlugin().fetchAlreadyGeneratedTokenFromFCM;
                      },
                      child: Text("FETCH ALREADY GENETATED TOEKN"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        var _shp = await SharedPreferences.getInstance();
                        String color = _shp.get("color") as String? ?? "";
                        if (color.isEmpty) {
                          var option = SMTNotificationOptions(
                              transparentIconBgColor: "#ff888888");
                          SmartechPlugin().setNotificationOptions(option);

                          _shp.setString("color", "ff888888");
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => SetIconColor()));
                      },
                      child: Text("NOTIFICATION ICON COLOR"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text("FETCH DELIVERD PUSH NOTIFICATIONS"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        var value = await SmartechPlugin().getInboxMessageCount(
                            SMTNotificatioMessageType.ALL_MESSAGE);
                        Fluttertoast.showToast(
                            msg: value.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 13.0);
                      },
                      child: Text("UNREAD PUSH NOTIFICATION COUNT"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text("PRODUCT RECOMMENDATION"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        var value = await SmartechPlugin().getDevicePushToken();

                        Fluttertoast.showToast(
                            msg: value.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 13.0);
                      },
                      child: Text("GET TOKEN"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        var value = await SmartechPlugin().getUserIdentity();
                        Fluttertoast.showToast(
                            msg: value.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 13.0);
                      },
                      child: Text("GET USER IDENTITY"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        var value = await SmartechPlugin().getDeviceUniqueId();

                        Fluttertoast.showToast(
                            msg: value.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 13.0);
                      },
                      child: Text("GET DEVICE UNIQUE ID"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().optPushNotification(true);
                      },
                      child: Text("OPT-IN Notification"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().optTracking(true);
                      },
                      child: Text("OPT-IN Tracking"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().optInAppMessage(true);
                      },
                      child: Text("OPT-IN in appmessage"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().optTracking(false);
                      },
                      child: Text("OPT-Out Tracking"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().optInAppMessage(false);
                      },
                      child: Text("OPT-OUT IN APPMESSAGE"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().trackAppInstallUpdateBySmartech();
                      },
                      child: Text("Track update and install by smartech"),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        SmartechPlugin().openNativeWebView();
                      },
                      child: Text("NATIVE TO WEBVIEW"),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => CustomeEventPage()));
                      },
                      child: Text("Track update and install by smartech"),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
