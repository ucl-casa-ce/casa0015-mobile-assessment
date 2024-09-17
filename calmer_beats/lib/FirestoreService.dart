import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch user's default duration
  Future<int?> getUserDefaultDuration(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection('users').doc(userId).get();
      Map<String, dynamic>? data = doc.data(); // Ensure the data is a Map
      if (data != null) {
        return data['defaultDuration'] as int?;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    return null;
  }

  // Fetch user's preference for displaying instructions
  Future<bool?> getUserDisplayInstructions(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection('users').doc(userId).get();
      Map<String, dynamic>? data = doc.data(); // Ensure the data is a Map
      if (data != null) {
        return data['displayInstructions'] as bool?;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    return null;
  }
}