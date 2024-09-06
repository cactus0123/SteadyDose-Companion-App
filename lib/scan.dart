// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:steady_dose_companion_app/connection_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // ignore: prefer_final_fields
  List<ScanResult> _scanResults = [];

  void scan() async {
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          setState(() {
            if (r.advertisementData.advName != "") {
              _scanResults.add(r);
            }
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
      if (state != BluetoothAdapterState.on) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please turn Bluetooth on'),
          ),
        );
      }
    });

    FlutterBluePlus.cancelWhenScanComplete(subscription);
  }

  @override
  void initState() {
    super.initState();
    handleBT();
    scan();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .map(
          (r) => Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading:
                  Icon(Icons.bluetooth, color: Theme.of(context).primaryColor),
              title: Text(
                r.advertisementData.advName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(r.device.remoteId.toString()),
              trailing: Icon(Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor),
              onTap: () async {
                // Handle the tap event here
                try {
                  await r.device.connect();
                  await r.device.requestMtu(512);
                  if (r.device.isConnected) {
                    print("Connected to ${r.advertisementData.advName}");
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ConnectionPage(device: r.device)));
                  }
                } catch (e) {
                  print("errah in tha debuggah");
                }
              },
            ),
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
