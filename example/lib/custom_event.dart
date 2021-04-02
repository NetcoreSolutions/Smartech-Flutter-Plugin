import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';
import 'package:smartech_plugin_example/set_colors.dart';

import 'main.dart';

class CustomeEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomeEventState();
}

class _CustomeEventState extends State<CustomeEventPage> {
  var eventName = '';
  var eventData = '';
  @override
  Widget build(BuildContext context) {
    Globle().context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Event"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(),
                child: TextField(
                  decoration: InputDecoration(hintText: "Event name"),
                  onChanged: (value) {
                    eventName = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(),
                child: TextField(
                  decoration: InputDecoration(hintText: "Event Data"),
                  onChanged: (value) {
                    eventData = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (eventName.isEmpty) {
                      showTost("Please Enter event Name");
                      return;
                    }
                    if (eventData.isEmpty) {
                      showTost("Please add event data");
                      return;
                    }
                    var jsonData = json.decode(eventData);

                    if (jsonData == null) {
                      showTost("event data not in proper formate");
                      return;
                    }
                    SmartechPlugin().trackEvent(eventName, jsonData);
                  },
                  child: Text("Send"))
            ],
          ),
        ),
      ),
    );
  }
}
