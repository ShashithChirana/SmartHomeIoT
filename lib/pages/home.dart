import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:ui';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  double humidity = 0.0;
  double temperature = 0.0;

  List<List<dynamic>> devices = [
    ["Bulb 01", "assets/icons/lock.png", false],
    ["Bulb 02", "assets/icons/window.png", false],
    ["Bulb 03", "assets/icons/smart-tv.png", false],
    ["Fan", "assets/icons/fan.png", false],
    ["Door", "assets/icons/light-bulb.png", false],
    ["Smart AC", "assets/icons/air-conditioner.png", false],
  ];

  @override
  void initState() {
    super.initState();
    _fetchHumidity();
    _fetchTemperature();
  }

  void _fetchHumidity() {
    _database.child('humidity').onValue.listen((event) {
      setState(() {
        humidity = (event.snapshot.value as double) / 100.0;
      });
    });
  }

  void _fetchTemperature() {
    _database.child('temperature').onValue.listen((event) {
      setState(() {
        temperature = (event.snapshot.value as double);
      });
    });
  }

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      devices[index][2] = value;
    });

    // Update Firebase
    String deviceName = devices[index][0].toLowerCase().replaceAll(" ", "_");
    _database.child('devices/$deviceName').set(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.dashboard, size: 40, color: Colors.white),
                    Icon(Icons.person, size: 40, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Smart Lodge System",
                      style: TextStyle(fontSize: 35, color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Humidity",
                                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20.0),
                              Icon(Icons.water_drop, size: 40, color: Colors.blue),
                              const SizedBox(height: 20.0),
                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 13.0,
                                percent: humidity,
                                center: Text(
                                  "${(humidity * 100).toStringAsFixed(1)}%",
                                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                                progressColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Temperature",
                                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20.0),
                              Icon(Icons.wb_sunny, size: 40, color: Colors.red),
                              const SizedBox(height: 20.0),
                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 13.0,
                                percent: temperature / 100, // Assuming temperature is a percentage
                                center: Text(
                                  "${temperature.toStringAsFixed(1)}°C",
                                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                ),
                                progressColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: const Text(
                  "Device List",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              GridView.builder(
                itemCount: devices.length,
                padding: const EdgeInsets.all(20.0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: devices[index][2]
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ]
                            : [],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Uncomment and use the following line if you have valid asset paths
                              // Image.asset(devices[index][1], height: 50),
                              Icon(Icons.home, size: 50), // Placeholder icon
                              CupertinoSwitch(
                                value: devices[index][2],
                                onChanged: (value) {
                                  powerSwitchChanged(value, index);
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                            child: Text(
                              devices[index][0],
                              style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
