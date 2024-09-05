// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  List<ScanResult> _scanResults = [];

  void scan() async {
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          setState(() {
            _scanResults.add(r);
          });
          print(
              '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        }
      },
      onError: (e) => print(e),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;
    // Start scanning w/ timeout
    // Optional: use `stopScan()` as an alternative to timeout
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  void handleBT() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth is not supported");
      return;
    }

    var subscription =
        FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        print("Bluetooth is on, scanning...");
        scan();
      } else {
        print("Bluetooth is off");
      }
    });

    subscription.cancel();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => ListTile(
            title: Text(r.advertisementData.advName),
            subtitle: Text(r.device.remoteId.toString()),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              scan();
            },
          ),
        ],
      ),
      body: ListView(
        children: _buildScanResultTiles(context),
      ),
    );
  }
}
