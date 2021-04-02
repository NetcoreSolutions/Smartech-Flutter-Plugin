package com.flutter.smartech.smartech_demo

import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import com.netcore.android.Smartech
import com.netcore.android.webview.SMTAppWebViewJavaScriptInterface
import com.netcore.android.webview.SMTAppWebViewListener
import java.lang.ref.WeakReference

class WebView :SMTAppWebViewListener, AppCompatActivity() {
    private val webView: WebView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_web_view)
        val webView = findViewById<WebView>(R.id.webView)
        webView.webViewClient = WebViewClient()

        val webSettings = webView.settings
        webSettings.javaScriptEnabled = true
        webSettings.domStorageEnabled = true
        webView.setWebViewClient(object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView, url: String?): Boolean {
                if (url != null) {
                    view.loadUrl(url)
                }
                return false
            }
        })

        val payload = HashMap<String, Any>()
        payload.put("world", "John")
        payload.put("count", 1)
        payload.put("tf", true)

        webView.addJavascriptInterface(SMTAppWebViewJavaScriptInterface(this,this),SMTAppWebViewJavaScriptInterface.SMT_INTERFACE_NAME)

        webView.loadUrl("https://demo1.netcoresmartech.com/devops1_prapp15/")
    }

    override fun handleWebEvent(eventName: String, eventPayLoad: HashMap<String, Any>?) {

    }

}