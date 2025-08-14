import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'beta_email';

  /// Save email to beta_email collection
  static Future<bool> saveBetaEmail(String email) async {
    try {
      await _firestore.collection(_collectionName).add({
        'email': email,
      });
      return true;
    } catch (e) {
      print('Error saving email to Firebase: $e');
      return false;
    }
  }

  /// Check if email already exists in the collection
  static Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
      return false;
    }
  }
}
