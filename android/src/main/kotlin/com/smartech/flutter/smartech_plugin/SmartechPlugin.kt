package com.smartech.flutter.smartech_plugin

import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.IntentFilter
import android.location.Location
import android.location.LocationManager
import android.util.Log
import androidx.annotation.NonNull
import com.netcore.android.Smartech
import com.netcore.android.notification.SMTNotificationOptions
import com.netcore.android.notification.channel.SMTNotificationChannel
import com.netcore.flutter.smartech.SmartechHTMLlistener
import io.flutter.app.FlutterApplication
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.lang.ref.WeakReference

/** SmartechPlugin */
class SmartechPlugin: FlutterPlugin, MethodCallHandler,ActivityAware,Application() {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private  var activityBinding: ActivityPluginBinding? = null
  private  var activity:Activity? = null
  private lateinit var smartech: Smartech
  private  lateinit var smartechHTMLlistener: SmartechHTMLlistener
  lateinit var sBackgroundService:FlutterEngine
  lateinit var channel : MethodChannel
  lateinit var mBackgroundChannel: MethodChannel

    override fun onCreate() {
        super.onCreate()
    }



  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setupPlugin(flutterPluginBinding,null)

   // initialBackgroundService()

  }

  fun setupPlugin(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding?,registrar: PluginRegistry.Registrar?) {

    if (registrar != null) {
      channel = MethodChannel(registrar?.messenger(), "smartech_plugin")
    } else {
      channel = MethodChannel(flutterPluginBinding?.binaryMessenger, "smartech_plugin")
    }

    channel.setMethodCallHandler(this)
    smartech = Smartech.getInstance(WeakReference(context))
    smartechHTMLlistener = SmartechHTMLlistener()
  }

  fun initialBackgroundService() {

    if (sBackgroundService == null) {
      sBackgroundService = FlutterEngine(context)

    }
    mBackgroundChannel = MethodChannel(sBackgroundService.dartExecutor.binaryMessenger, "smartech_plugin_background")
    mBackgroundChannel.setMethodCallHandler(this)
  }

  private fun runOnMainThread(runnable: Runnable) {
   if (activity == null) {
     activity = FlutterActivity()
   }
    if (activity != null) {
      activity?.runOnUiThread(runnable)
    } else {
      try {
        (context as Activity).runOnUiThread(runnable)
      } catch (e: Exception) {
        Log.e("FlutterPlugin", "Exception while running on main thread - ")
        e.printStackTrace()
      }
    }
  }


  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")

      }

      "setDevicePushToken" -> {
        setDevicePushToken(call.arguments as String)
        result.success("DevicePushToken set")

      }
      "fetchAlreadyGeneratedTokenFromFCM" -> {
        smartech.fetchAlreadyGeneratedTokenFromFCM()

        result.success("fetchAlreadyGeneratedTokenFromFCM set")

      }
      "setDebugLevel" -> {
        if (call.arguments is Int) {
          setDebugLevel(call.arguments as Int)
        } else {
          result.error("", "level should be in int", null)
        }
      }
      "trackAppInstall" -> {
        trackAppInstall()
      }
      "trackAppUpdate" -> {
        trackAppUpdate()
      }
      "trackAppInstallUpdateBySmartech" -> {

        trackAppInstallUpdateBySmartech()

      }
      "setInAppCustomHTMLListener" -> {
        setInAppCustomHTMLListener()
        smartechHTMLlistener.smartechHTMLlistenerCallBack = {

          runOnMainThread(Runnable {
            channel.invokeMethod("setInAppCustomHTMLListener", it)
          })
        }
      }
      "handlePushNotification" -> {
        handlePushNotification(call.arguments as String)
      }
      "createNotificationChannel" -> {
        createNotificationChannel(call.arguments as HashMap<String, Any>)
      }
      "createNotificationChannelGroup" -> {
        createNotificationChannelGroup(call.arguments as HashMap<String, Any>)
      }
      "deleteNotificationChannel" -> {
        deleteNotificationChannel(call.arguments as String)
      }
      "deleteNotificationChannelGroup" -> {
        deleteNotificationChannelGroup(call.arguments as String)
      }
      "updateUserProfile" -> {
        updateUserProfile(call.arguments as HashMap<String, Any>)
      }
      "setUserIdentity" -> {
        setUserIdentity(call.arguments as String)
      }
      "login" -> {
        login(call.arguments as String)
        channel.invokeMethod("caca", "asa")
      }
      "clearUserIdentity" -> {
        smartech.clearUserIdentity()
      }
      "logoutAndClearUserIdentity" -> {
        smartech.logoutAndClearUserIdentity(call.arguments as Boolean)
      }
      "trackEvent" -> {
        trackEvent(call.arguments as HashMap<String, Any>)
      }
      "setNotificationOptions" -> {
        setNotificationOptions(call.arguments as HashMap<String, Any>)
      }
      "getDeviceUniqueId" -> {
        val guid = smartech.getDeviceUniqueId()
        result.success(guid)
      }
      "setUserLocation" -> {
        setUserLocation(call.arguments as HashMap<String, Any>)
      }
      "optTracking" -> {
        smartech.optTracking(call.arguments as Boolean)
      }
      "hasOptedTracking" -> {
        result.success(smartech.hasOptedTracking())
      }
      "optPushNotification" -> {
        smartech.optPushNotification(call.arguments as Boolean)
      }
      "hasOptedPushNotification" -> {
        result.success(smartech.hasOptedPushNotification())
      }
      "optInAppMessage" -> {
        smartech.optInAppMessage(call.arguments as Boolean)

      }
      "hasOptedInAppMessage" -> {
        result.success(smartech.hasOptedInAppMessage())
      }
      "processEventsManually" -> {
        smartech.processEventsManually()

      }
      "getUserIdentity" -> {
        result.success(smartech.getUserIdentity())
      }
      "getInboxMessageCount" -> {
        result.success(smartech.getInboxMessageCount(call.arguments as Int))
      }
      "getDevicePushToken" -> {
        result.success(smartech.getDevicePushToken())
      }
      "openNativeWebView" -> {
        openNativeWebView?.invoke()
      }
      "onhandleDeeplinkAction" -> {
        DeeplinkReceivers.deeplinkReceiverCallBack = { deepLinkUrl, payload ->


          if (deepLinkUrl != null) {
            var map = HashMap<String, Any>()

            map.put("deeplinkURL", deepLinkUrl)

            if (payload != null) {
              map.put("customPayload", payload)
            }
            Log.d("onReceive", "onReceive onInvoke post")
            Log.d("onReceive", map.toString())

            context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).edit().putString("deepLinkUrl", deepLinkUrl).putString("payload", payload).apply()

            runOnMainThread(Runnable {
              channel.invokeMethod("onhandleDeeplinkAction", map, object : MethodChannel.Result {
                override fun success(result: Any?) {
                  context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).edit().clear().apply()
                  Log.d("success", "success")
                }

                override fun error(code: String?, msg: String?, details: Any?) {
                  if (msg != null) {
                    Log.d("success111", msg)
                  }
                }

                override fun notImplemented() {
                  Log.d("notImplemented", "notImplemented")
                }
              })
            })


          }


        }
      }
      "onhandleDeeplinkActionBackground" -> {
        val deeplinkUrl = context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).getString("deepLinkUrl", null)
        val payload = context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).getString("payload", null)
        if (deeplinkUrl != null) {
          Log.d("deeplinkUrl", deeplinkUrl)
          var map = HashMap<String, Any>()

          map.put("deeplinkURL", deeplinkUrl)

          if (payload != null) {
            map.put("customPayload", payload)
          }

          runOnMainThread(Runnable {
            channel.invokeMethod("onhandleDeeplinkAction", map, object : MethodChannel.Result {
              override fun success(result: Any?) {
                context.getSharedPreferences("Deeplink_action", Context.MODE_PRIVATE).edit().clear().apply()
                Log.d("success", "success")
              }

              override fun error(code: String?, msg: String?, details: Any?) {
                if (msg != null) {
                  Log.d("success111", msg)
                }
              }

              override fun notImplemented() {
                Log.d("notImplemented", "notImplemented")
              }
            })
          })
        }
      }
      "openUrl" -> {
        openUrl?.invoke(call.arguments as String)
      }

      else -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
    }

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }








  private  fun setInAppCustomHTMLListener() {
    val options = SMTNotificationOptions(context)

    smartech.setInAppCustomHTMLListener(smartechHTMLlistener)
  }



  private fun getIconResourceId(iconName: String) : Int {
    return context.getResources().getIdentifier(iconName, DRAWABLE, context.getPackageName())
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.d("activity", "Attached")
    activityBinding = binding
    activity = binding.activity

  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
      Log.d("activity", "Change")
    activityBinding = binding
activity = binding.activity
  }

  override fun onDetachedFromActivity() {
  }

  private fun setNotificationOptions(payload: HashMap<String, Any>) {
    val option = SMTNotificationOptions(context)
    if (payload["smallIconTransparentId"] != null) {
      option.smallIconTransparentId = getIconResourceId(payload["smallIconTransparentId"] as String)
    }
    if (payload["largeIconId"] != null) {
      option.largeIconId = getIconResourceId(payload["largeIconId"] as String)
    }
    if (payload["placeHolderIcon"] != null) {
      option.placeHolderIcon = getIconResourceId(payload["placeHolderIcon"] as String)
    }
    if (payload["smallIconId"] != null) {
      option.smallIconId = getIconResourceId(payload["smallIconId"] as String)
    }
    if (payload["transparentIconBgColor"] != null) {
      option.transparentIconBgColor = payload["transparentIconBgColor"] as String
    }
  smartech.setNotificationOptions(option)
  }

  private fun createNotificationChannel(payload: HashMap<String, Any>) {
    val builder : SMTNotificationChannel.Builder =  SMTNotificationChannel.Builder(
            payload["Channel_ID"] as String,
            payload["Channel_Name"] as String,
            payload["Notification_Importance"] as Int
    )
    if (payload["Channel_Description"] != null) {
      builder.setChannelDescription(payload["Channel_Description"] as String)
    }

    if (payload["Group_ID"] != null) {
      builder.setChannelGroupId(payload["Group_ID"] as String)
    }

    if (payload["Sound_File_Name"] != null) {
      builder.setNotificationSound(payload["Sound_File_Name"] as String)
    }
    val smtNotificationChannel: SMTNotificationChannel = builder.build()
    smartech.createNotificationChannel(smtNotificationChannel)

  }

  private fun createNotificationChannelGroup(payload: HashMap<String, Any>) {
    smartech.createNotificationChannelGroup(payload["group_id"] as String, payload["group_name"] as String)
  }

  private fun deleteNotificationChannel(channelId: String) {
    smartech.deleteNotificationChannel(channelId)
  }

  private  fun deleteNotificationChannelGroup(groupId: String) {
    smartech.deleteNotificationChannelGroup(groupId)
  }

  private fun updateUserProfile(payload: HashMap<String, Any>) {
    smartech.updateUserProfile(payload)
  }

  private  fun setUserIdentity(userIdentity: String?) {
    smartech.setUserIdentity(userIdentity)
  }

  private  fun login(userIdentity: String?) {
    smartech.login(userIdentity)
  }



  private  fun setUserLocation(payload: HashMap<String, Any>) {

    var targetlocation = Location(LocationManager.GPS_PROVIDER)
    targetlocation.latitude = payload["latitude"] as Double
    targetlocation.longitude = payload["longitude"] as Double
    smartech.setUserLocation(targetlocation);
  }

  private  fun trackEvent(payload: HashMap<String, Any>) {
    smartech.trackEvent(payload["event_name"] as String, payload["event_data"] as HashMap<String, Any>)
  }

  companion object {



    lateinit var context: Context
    var DRAWABLE = "drawable"
    val deeplinkReceiver = DeeplinkReceivers()
    val filter = IntentFilter("com.smartech.EVENT_PN_INBOX_CLICK")
    var  openNativeWebView : (()->Unit)? = null
    var  openUrl : ((url: String?)->Unit)? = null
      lateinit var app:Application
    fun setDevicePushToken(token: String) {
      Smartech.getInstance(WeakReference(context)).setDevicePushToken(token)
    }

    fun  initializePlugin(application: Application) {
      context = application.applicationContext
        app = application

      Smartech.getInstance(WeakReference(application.applicationContext)).initializeSdk(application)

    }

    fun handlePushNotification(notificationData: String?) {
      Smartech.getInstance(WeakReference(context)).handlePushNotification(notificationData)
    }
      fun trackAppInstallUpdateBySmartech() {
      Smartech.getInstance(WeakReference(context)).trackAppInstallUpdateBySmartech()
    }

      fun  setDebugLevel(level: Int) {
        Smartech.getInstance(WeakReference(context)).setDebugLevel(level)
    }

     fun trackAppInstall() {
       Smartech.getInstance(WeakReference(context)).trackAppInstall()
    }

      fun trackAppUpdate() {
        Smartech.getInstance(WeakReference(context)).trackAppUpdate()

    }

    @JvmStatic
    fun  registerWith(registrar: PluginRegistry.Registrar){
      val smartechPlugin = SmartechPlugin()
      smartechPlugin.setupPlugin(null,registrar)
    }

  }


}


