import 'package:flutter/material.dart';
import 'package:steady_dose_companion_app/scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steady Dose Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 33, 92, 193)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SteadyDose'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _connected = false;

  bool connectBT() {
    setState(() {
      _connected = true;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Spacer(),
          Padding(
            padding:
                const EdgeInsets.all(20), // Adjust the top padding as needed
            child: Image.asset('lib/Images/steadydoselogo.png',
                width: 200, height: 200),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
          ), // Spacer to push the text to the center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome to SteadyDose Companion',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                ), // Spacer to push the text to the center
                ElevatedButton(
                  onPressed: () {
                    print("skibidi");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(200, 100),
                  ),
                  child: const Text(
                    "Please connect to your device",
                  ),
                ),
              ],
            ),
          ),
          const Spacer(), // Spacer to push the text to the center
        ],
      ),
    );
  }
}
