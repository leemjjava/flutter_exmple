import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class PanoramaExample extends StatefulWidget {
  static const String routeName = '/examples/panorama_example';
  @override
  _PanoramaExampleState createState() => _PanoramaExampleState();
}

class _PanoramaExampleState extends State<PanoramaExample> {
  void onViewChanged(longitude, latitude, tilt) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Panorama(
          animSpeed: 0.0,
          sensitivity: 3,
          sensorControl: SensorControl.None,
          onViewChanged: onViewChanged,
          child: Image.asset("assets/test_360.jpeg"),
        ),
      ),
    );
  }
}
