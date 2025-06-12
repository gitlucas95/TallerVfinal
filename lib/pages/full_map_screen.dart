import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class FullMapScreen extends StatefulWidget {
  const FullMapScreen({super.key});

  @override
  FullMapScreenState createState() => FullMapScreenState();
}

class FullMapScreenState extends State<FullMapScreen> {
  late GoogleMapController mapController;
  LatLng _currentPosition = const LatLng(-12.0464, -77.0428);
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado')),
        );
      }
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _addMarkers();
      });

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener ubicación: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void _addMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Tu ubicación actual'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (!_isLoading) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    }
  }

  void _reportSpace() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Espacio ofrecido desde esta ubicación')),
    );
  }

  void _searchNearby() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buscando estacionamientos cercanos')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? action =
        ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de ParkAmigo'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition,
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                ),

                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Buscar estacionamiento...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Botón de acción según el origen
                if (action == 'ofrecer' || action == 'buscar')
                  Positioned(
                    top: 80,
                    left: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (action == 'ofrecer') {
                          _reportSpace();
                        } else {
                          _searchNearby();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black38,
                      ),
                      icon: Icon(
                        action == 'ofrecer'
                            ? Icons.share_location
                            : Icons.search,
                        color: Colors.blue,
                      ),
                      label: Text(
                        action == 'ofrecer' ? 'Ofrecer aquí' : 'Buscar cerca',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
