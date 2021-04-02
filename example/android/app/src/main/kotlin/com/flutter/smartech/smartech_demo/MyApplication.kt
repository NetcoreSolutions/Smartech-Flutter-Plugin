package com.flutter.smartech.smartech_demo

import android.app.Application
import android.content.IntentFilter
import android.util.Log
import com.smartech.flutter.smartech_plugin.DeeplinkReceivers
import com.smartech.flutter.smartech_plugin.SmartechPlugin
import io.flutter.app.FlutterApplication

class MyApplication: FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Log.d("onCreate","onCreate")
         SmartechPlugin.initializePlugin(this)
        SmartechPlugin.setDebugLevel(9)
        SmartechPlugin.trackAppInstallUpdateBySmartech()
        val deeplinkReceiver = DeeplinkReceivers()
        val filter = IntentFilter("com.smartech.EVENT_PN_INBOX_CLICK")
        registerReceiver(deeplinkReceiver,filter)
    }

    override fun onTerminate() {
        super.onTerminate()
        Log.d("onTerminate","onTerminate")
        System.exit(0);

    }
}