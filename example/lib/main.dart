import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_device_unique_id/flutter_device_unique_id_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _uniqueId = 'Unknown';

  @override
  void initState() {
    super.initState();

    _initUniqueId();
  }

  Future<void> _initUniqueId() async {
    String uniqueId;

    uniqueId =
        await FlutterDevicePlatform.instance.getUniqueId() ?? 'Unknown ID';

    if (!mounted) return;

    setState(() => _uniqueId = uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(child: Text('Unique ID: $_uniqueId')),
      ),
    );
  }
}
