import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation with Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationMap1(),
    );
  }
}

class NavigationMap1 extends StatefulWidget {
  const NavigationMap1({super.key});

  @override
  State<NavigationMap1> createState() => _NavigationMap1State();
}

class _NavigationMap1State extends State<NavigationMap1> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fun ();
  }
  late MapController controller;
  late RoadInfo roadInfo;
  Future<void> fun() async {

    // default constructor
    controller = MapController.customLayer(
      initPosition:
      GeoPoint(
          latitude: 12.904036,
          longitude: 80.118652
      ),
      customTile: CustomTile(
        sourceName: "opentopomap",
        tileExtension: ".png",
        minZoomLevel: 2,
        maxZoomLevel: 19,
        urlsServers: [
          TileURLs(
            //"https://tile.opentopomap.org/{z}/{x}/{y}"
            url: "https://tile.opentopomap.org/",
            subdomains: [],
          )
        ],
        tileSize: 256,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: Stack(
              children: [
                OSMFlutter(
                    controller: controller,
                    osmOption: OSMOption(
                      userTrackingOption: UserTrackingOption(
                        enableTracking: true,
                        unFollowUser: false,
                      ),
                      zoomOption: ZoomOption(
                        initZoom: 8,
                        minZoomLevel: 3,
                        maxZoomLevel: 19,
                        stepZoom: 1.0,
                      ),staticPoints: [
                      StaticPositionGeoPoint('id', MarkerIcon(icon: Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 56,
                      ),),[
                        GeoPoint(
                            latitude: 12.904036,
                            longitude: 80.118652
                        ),
                        GeoPoint(
                          latitude: 12.861531,
                          longitude: 80.077426,
                        ),
                      ]
                      )
                    ],
                      userLocationMarker: UserLocationMaker(
                        personMarker: MarkerIcon(
                          icon: Icon(
                            Icons.location_history_rounded,
                            color: Colors.red,
                            size: 48,
                          ),
                        ),
                        directionArrowMarker: MarkerIcon(
                          icon: Icon(
                            Icons.double_arrow,
                            size: 48,
                          ),
                        ),
                      ),
                      roadConfiguration: RoadOption(
                        roadColor: Colors.yellowAccent,
                      ),
                    )
                ),
                Expanded(child: Container(color: Colors.blue,))
              ],
            ),
          ),
        ),
        ElevatedButton(onPressed: () async {
          roadInfo = await controller.drawRoad(
            GeoPoint(
                latitude: 12.904036,
                longitude: 80.118652
            ),
            GeoPoint(
              latitude: 12.861531,
              longitude: 80.077426,
            ),
            roadType: RoadType.car,
            intersectPoint : [
              GeoPoint(
                  latitude: 12.904036,
                  longitude: 80.118652
              ),
              GeoPoint(
                latitude: 12.861531,
                longitude: 80.077426,
              ),],
            roadOption: RoadOption(
              roadWidth: 10,
              roadColor: Colors.blue,
              zoomInto: true,
            ),
          );
          print("${roadInfo.distance}km");
          print("${roadInfo.duration}sec");
          print("${roadInfo.instructions}");
          setState(() {

          });
        }, child: Text('kk'))
      ],
    );
  }
}


// class NavigationMap extends StatefulWidget {
//   @override
//   _NavigationMapState createState() => _NavigationMapState();
// }
//
//
// class _NavigationMapState extends State<NavigationMap> {
//   final MapController _mapController = MapController();
//   LatLng _currentLocation = LatLng(12.904036, 80.118652);
//   LatLng _destination = LatLng(12.861531, 80.077426); // Default destination
//   List<LatLng> _routeCoordinates = [];
//   bool _isNavigationActive = false;
//   bool _isLoading = true;
//   TextEditingController _searchController = TextEditingController();
//
//
//   // Function to fetch route coordinates from OpenRouteService API
//   Future<void> _getRouteCoordinates() async {
//     final apiKey = "YOUR_OPENROUTESERVICE_API_KEY"; // Replace with your OpenRouteService API key
//     final url = Uri.parse(
//       'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${_currentLocation.longitude},${_currentLocation.latitude}&end=${_destination.longitude},${_destination.latitude}',
//     );
//
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final coordinates = data['features'][0]['geometry']['coordinates'];
//
//       setState(() {
//         _routeCoordinates = coordinates
//             .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
//             .toList();
//       });
//     } else {
//       print("Error fetching route");
//     }
//   }
//
//   Future<void> _searchLocation(String query) async {
//     final apiKey = "YOUR_OPENCAGE_API_KEY"; // Replace with your OpenCage API key
//     final url = Uri.parse(
//       'https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey',
//     );
//
//
//     Future<void> _fetchCurrentLocation() async {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//       });
//
//       // Center the map on the current location
//       _mapController.move(_currentLocation!, 15.0);
//     }
//
//     Future<void> getLocationPermission() async {
//       bool serviceEnabled;
//       LocationPermission permission;
//
//       // Check if location services are enabled
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         // Prompt to enable location services
//         await Geolocator.openLocationSettings();
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }
//
//       // Check location permission
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           // Permissions are denied
//           setState(() {
//             _isLoading = false;
//           });
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }
//
//       await _fetchCurrentLocation();
//     }
//
//
//
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['results'].isNotEmpty) {
//         final lat = data['results'][0]['geometry']['lat'];
//         final lng = data['results'][0]['geometry']['lng'];
//
//         setState(() {
//           getLocationPermission();
//           _destination = LatLng(lat, lng);
//         });
//
//         // After setting the new destination, fetch the route
//         _getRouteCoordinates();
//       } else {
//         print("No results found");
//       }
//     } else {
//       print("Error fetching location data");
//     }
//   }
//
//   void _startNavigation() {
//     _getRouteCoordinates();
//     setState(() {
//       _isNavigationActive = true;
//     });
//   }
//
//   void _stopNavigation() {
//     setState(() {
//       _isNavigationActive = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navigation with Search'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Location',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     if (_searchController.text.isNotEmpty) {
//                       _searchLocation(_searchController.text);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 initialCenter: _currentLocation ?? LatLng(0.0, 0.0),
//                 initialZoom: 15.0,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                   subdomains: ['a', 'b', 'c'],
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: _currentLocation,
//                       width: 40.0,
//                       height: 40.0,
//                       child: Icon(
//                         Icons.location_on,
//                         color: Colors.blue,
//                         size: 40.0,
//                       ),
//                     ),
//                     Marker(
//                       point: _destination,
//                       width: 40.0,
//                       height: 40.0,
//                       child: Icon(
//                         Icons.location_on,
//                         color: Colors.red,
//                         size: 40.0,
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (_isNavigationActive)
//                   PolylineLayer(
//                     polylines: [
//                       Polyline(
//                         points: _routeCoordinates,
//                         strokeWidth: 4.0,
//                         color: Colors.blueAccent,
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: _isNavigationActive ? _stopNavigation : _startNavigation,
//               child: Text(_isNavigationActive ? 'Stop Navigation' : 'Start Navigation'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }