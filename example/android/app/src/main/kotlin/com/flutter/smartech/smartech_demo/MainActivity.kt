package com.flutter.smartech.smartech_demo

import android.Manifest
import android.app.AlertDialog
import android.content.DialogInterface
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.smartech.flutter.smartech_plugin.DeeplinkReceivers
import com.smartech.flutter.smartech_plugin.SmartechPlugin
import io.flutter.embedding.android.FlutterActivity
import java.util.*

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        DeeplinkReceivers().onReceive(this, intent)
        SmartechPlugin.openNativeWebView = {

            val intent = Intent(this, WebView::class.java)

            startActivity(intent)




        }
        SmartechPlugin.openUrl = {
            if (it != null) {
                openUrl(it)
            }
        }
        Log.d("MainActivity", "MainActivity open2")

    }

    fun openUrl(url:String) {

        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }

    override fun onResume() {
        super.onResume()
    }


}



