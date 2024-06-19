package com.example.phishingmagajo

import android.database.Cursor
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.yourcompany.yourapp/sms"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSms") {
                val messages = getSmsFromInbox()
                result.success(messages)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getSmsFromInbox(): String {
        val uri: Uri = Uri.parse("content://sms/inbox")
        val cursor: Cursor? = contentResolver.query(uri, null, null, null, null)
        val stringBuilder = StringBuilder()

        cursor?.let {
            while (it.moveToNext()) {
                val address = it.getString(it.getColumnIndexOrThrow("address"))
                val body = it.getString(it.getColumnIndexOrThrow("body"))
                stringBuilder.append("SMS from $address: $body\n")
            }
            it.close()
        }
        return stringBuilder.toString()
    }
}
