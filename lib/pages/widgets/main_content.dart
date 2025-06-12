import 'package:flutter/material.dart';
import 'package:estacionarapp/pages/parking_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'feature_tile.dart';
import 'package:estacionarapp/pages/LocationService.dart';
import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  final Color primaryBlue = const Color(0xFF2563EB);
  final Color darkBlue = const Color(0xFF1E40AF);
  final Color textColor = const Color(0xFF1F2937);

  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final double horizontalPadding = isMobile ? 20.0 : 40.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Icon(Icons.local_parking, size: 48, color: primaryBlue),
                    const SizedBox(height: 16),
                    Text(
                      'Encuentra estacionamiento\nde forma fácil y rápida',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Visualiza espacios disponibles en tiempo real y comparte tu cochera con vecinos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: textColor.withOpacity(0.7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: isMobile ? 200 : 300,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(-34.6037,
                                -58.3816), // Buenos Aires, o podés usar la ubicación actual
                            zoom: 14,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          liteModeEnabled: true, // Modo liviano para preview
                          onTap: (_) =>
                              Navigator.pushNamed(context, '/fullmap'),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/fullmap'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fullscreen,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/fullmap'),
                child: Text(
                  'Ver mapa completo',
                  style: TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: isMobile
                    ? Column(
                        children: [
                          _buildPrimaryButton(
                            text: 'Buscar estacionamiento',
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/fullmap',
                              arguments: 'buscar',
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSecondaryButton(
                            text: 'Ofrecer mi espacio',
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/fullmap',
                              arguments: 'ofrecer',
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _buildPrimaryButton(
                              text: 'Buscar estacionamiento',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                '/fullmap',
                                arguments: 'buscar',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSecondaryButton(
                              text: 'Ofrecer mi espacio',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                '/fullmap',
                                arguments: 'ofrecer',
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    Text(
                      'Características principales',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    isMobile
                        ? Column(
                            children: const [
                              FeatureTile(
                                icon: Icons.timer,
                                title: 'Disponibilidad en tiempo real',
                                description:
                                    'Visualiza en el mapa los espacios disponibles.',
                              ),
                              SizedBox(height: 24),
                              FeatureTile(
                                icon: Icons.group,
                                title: 'Comunidad colaborativa',
                                description: 'Comparte tu cochera con vecinos.',
                              ),
                              SizedBox(height: 24),
                              FeatureTile(
                                icon: Icons.schedule,
                                title: 'Coordinación de horarios',
                                description:
                                    'Notifica a otros cuando estés por dejar tu espacio.',
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Expanded(
                                child: FeatureTile(
                                  icon: Icons.timer,
                                  title: 'Disponibilidad en tiempo real',
                                  description:
                                      'Visualiza en el mapa los espacios disponibles.',
                                ),
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: FeatureTile(
                                  icon: Icons.group,
                                  title: 'Comunidad colaborativa',
                                  description:
                                      'Comparte tu cochera con vecinos.',
                                ),
                              ),
                              SizedBox(width: 24),
                              Expanded(
                                child: FeatureTile(
                                  icon: Icons.schedule,
                                  title: 'Coordinación de horarios',
                                  description:
                                      'Notifica a otros cuando estés por dejar tu espacio.',
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    Text(
                      '¿Listo para empezar?',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Regístrate ahora y encuentra estacionamiento en minutos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildPrimaryButton(
                      text: 'Registrate ahora',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reportParkingSpot(BuildContext context) async {
    final position = await LocationService.getCurrentPosition(context);
    if (position != null) {
      await reportParkingSpot(
        latitude: position.latitude,
        longitude: position.longitude,
        status: 'free',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Espacio ofrecido correctamente'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryBlue,
        ),
      );
    }
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: primaryBlue,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
