import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/horoscope_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save user profile
  Future<void> saveUserProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  // Get user profile
  Future<UserModel?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Save horoscope reading
  Future<void> saveHoroscope(String uid, HoroscopeModel horoscope) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('horoscopes')
        .doc(horoscope.id) // e.g., '2023-10-31'
        .set(horoscope.toMap());
  }

  // Get past horoscopes ordered by date
  Future<List<HoroscopeModel>> getHoroscopeHistory(String uid) async {
    QuerySnapshot snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('horoscopes')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return HoroscopeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Clear all past horoscopes
  Future<void> clearHistory(String uid) async {
    var collection = _db.collection('users').doc(uid).collection('horoscopes');
    var snapshots = await collection.get();
    
    WriteBatch batch = _db.batch();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
