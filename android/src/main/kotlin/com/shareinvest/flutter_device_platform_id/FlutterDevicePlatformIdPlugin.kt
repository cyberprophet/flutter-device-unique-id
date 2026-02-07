package com.shareinvest.flutter_device_platform_id

import androidx.annotation.NonNull
import android.annotation.SuppressLint
import android.content.ContentResolver
import android.provider.Settings

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterDevicePlatformIdPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var contentResolver: ContentResolver

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        contentResolver = flutterPluginBinding.applicationContext.contentResolver
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_device_platform_id")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getUniqueId" -> result.success(getAndroidId())

            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")

            else -> result.notImplemented()
        }
    }

    @SuppressLint("HardwareIds")
    private fun getAndroidId(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
    }
}