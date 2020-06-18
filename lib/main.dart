import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MapLauncherDemo());

class MapLauncherDemo extends StatelessWidget {
  double lat = 18.0269;
  double lon = 154.3485;

  openMapsSheet(context) async {
    try {
      final title = "Current Position of ISS";
      final description = "XxX";
      final response =
          await http.get('http://api.open-notify.org/iss-now.json');
      final jsonResponse = json.decode(response.body);

      lat = double.parse(jsonResponse['iss_position']['latitude']);
      lon = double.parse(jsonResponse['iss_position']['longitude']);

      final coords = Coords(lat, lon);
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Locate ISS'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('space.jpg'),
            fit: BoxFit.cover,
          )),
          child: Center(child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.black38,
                    onPressed: () => openMapsSheet(context),
                    child: Text(
                      'Show On Map',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          )),
        ),
      ),
    );
  }
}
