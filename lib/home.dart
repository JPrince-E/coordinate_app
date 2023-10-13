import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String longitude = '';
  String latitude = '';
  String? _error;

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        latitude = '${position.latitude}';
        longitude = '${position.longitude}';
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      setState(() {
        _error = 'Location permission denied.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_error != null)
              Text('Error: $_error')
            else
              Column(
                children: [
                  Text("Longitude: $longitude"),
                  const SizedBox(height: 50),
                  Text("Latitude: $latitude"),
                  const SizedBox(height: 50),
                ],
              ),
            const Text("Get your precise location here"),

            ElevatedButton(
              onPressed: _checkLocationPermission,
              child: const Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}
