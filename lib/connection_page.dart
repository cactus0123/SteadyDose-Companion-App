import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectionPage extends StatelessWidget {
  final BluetoothDevice device;

  const ConnectionPage({super.key, required this.device});

  void handleConnection() async {
    List<BluetoothService> services = await device.discoverServices();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // Your widget code here
        );
  }
}
