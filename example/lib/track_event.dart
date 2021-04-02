import 'package:flutter/material.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

import 'main.dart';

class TarckEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Event"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      var eventData = {"pageName": "set Event"};
                      SmartechPlugin().trackEvent("Page Browse", eventData);
                    },
                    child: Text("PAGE BROWSE"),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      var eventData = {
                        "prqt": 1,
                        "name": "Inapp Integer",
                        "prid": 10,
                        "price": 99.89
                      };
                      SmartechPlugin().trackEvent("Add To Cart", eventData);
                    },
                    child: Text("ADD TO CART"),
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
                      var eventData = {
                        "prqt": 1,
                        "name": "Inapp Integer",
                        "prid": 10,
                        "price": 99.89
                      };
                      SmartechPlugin().trackEvent("Checkout", eventData);
                    },
                    child: Text("CHECKOUT"),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      var eventData = {
                        "prqt": 1,
                        "name": "Inapp Integer",
                        "prid": 10,
                        "price": 99.89
                      };
                      SmartechPlugin()
                          .trackEvent("Remove From Cart", eventData);
                    },
                    child: Text("Remove From Cart"),
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
                      var eventData = {
                        "prqt": 1,
                        "name": "Inapp Integer",
                        "prid": 10,
                        "price": 99.89
                      };
                      SmartechPlugin().trackEvent("Expiry Cart", eventData);
                    },
                    child: Text("Expiry Cart"),
                  )),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Expanded(
                  //     child: ElevatedButton(
                  //   onPressed: () {
                  //     var eventData = {
                  //       "prqt": 1,
                  //       "name": "Inapp Integer",
                  //       "prid": 10,
                  //       "price": 99.89
                  //     };
                  //     SmartechPlugin().trackEvent("Expiry Cart", eventData);
                  //   },
                  //   child: Text("EXPIRY CART"),
                  // ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
