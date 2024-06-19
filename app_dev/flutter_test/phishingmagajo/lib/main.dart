import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.yourcompany.yourapp/sms');
  String _messages = "No messages.";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }

    if (status.isGranted) {
      _getSms();
    } else {
      setState(() {
        _messages = "SMS permission denied.";
      });
    }
  }

  Future<void> _getSms() async {
    String messages;
    try {
      messages = await platform.invokeMethod('getSms');
    } on PlatformException catch (e) {
      messages = "Failed to get messages: '${e.message}'.";
    }

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Received SMS'),
      ),
      body: Center(
        child: Text(_messages),
      ),
    );
  }
}
