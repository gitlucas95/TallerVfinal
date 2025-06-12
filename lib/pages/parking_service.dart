import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> reportParkingSpot({
  required double latitude,
  required double longitude,
  required String status,
}) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('Usuario no autenticado');
  }

  await FirebaseFirestore.instance.collection('parking_spots').add({
    'userId': user.uid,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'timestamp': DateTime.now().toIso8601String(),
  });
}
