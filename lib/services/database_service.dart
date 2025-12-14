import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  final String _usersCollection = 'users';
  final String _couplesCollection = 'couples';

  // Save user data
  Future<void> saveUserData({String? name}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDocRef = _db.collection(_usersCollection).doc(user.uid);

    // Check if user document exists
    final docSnapshot = await userDocRef.get();

    if (!docSnapshot.exists) {
      // Generate a random 6-digit couple code
      String inviteCode = _generateInviteCode();

      // Create start document
      await userDocRef.set({
        'uid': user.uid,
        'email': user.email,
        'name': name ?? user.displayName ?? '',
        'inviteCode': inviteCode,
        'coupleId': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Utility to generate a random 6-digit invite code
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  // Get user data
  Stream<DocumentSnapshot> getUserStream() {
    final uid = _auth.currentUser?.uid;
    return _db.collection(_usersCollection).doc(uid).snapshots();
  }

  // Try to join a couple using an invite code
  Future<bool> linkPartner(String inputCode) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('No authenticated user');

      final querySnapshot = await _db.collection(_usersCollection).where('inviteCode', isEqualTo: inputCode).get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Invalid invite code');
      }

      final partnerDoc = querySnapshot.docs.first;
      final partnerData = partnerDoc.data();

      // Validations before linking
      if (partnerDoc.id == currentUser.uid) {
        throw Exception('Cannot link with yourself');
      }
      if (partnerData['coupleId'] != null) {
        throw Exception('Partner is already linked');
      }

      // Create couple document
      final newCoupleRef = _db.collection(_couplesCollection).doc();
      // Update both users with the coupleId
      final batch = _db.batch();

      batch.set(newCoupleRef, {
        'id': newCoupleRef.id,
        'userA': currentUser.uid,
        'userB': partnerDoc.id,
        'startedAt': FieldValue.serverTimestamp(),
      });

      // Update current user
      batch.update(_db.collection(_usersCollection).doc(currentUser.uid), {'coupleId': newCoupleRef.id});

      // Update partner user
      batch.update(_db.collection(_usersCollection).doc(partnerDoc.id), {'coupleId': newCoupleRef.id});

      await batch.commit();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Add a memory
  Future<void> addMemory({
    required String coupleId,
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String category,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Reference to memories collection
    final memoriesRef = _db.collection('memories');

    // Create new memory document
    await memoriesRef.add({
      'coupleId': coupleId,
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'category': category,
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get memories stream for a couple
  Stream<QuerySnapshot> getMemoriesStream(String coupleId) {
    return _db
        .collection('memories')
        .where('coupleId', isEqualTo: coupleId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Delete a memory
  Future<void> deleteMemory(String memoryId) async {
    await _db.collection('memories').doc(memoryId).delete();
  }

  // Update a memory
  Future<void> updateMemory({
    required String memoryId,
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String category,
  }) async {
    await _db.collection('memories').doc(memoryId).update({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'category': category,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update startedAt date of couple
  Future<void> updateRelationshipStart(String coupleId, DateTime date) async {
    await _db.collection(_couplesCollection).doc(coupleId).update({'startedAt': Timestamp.fromDate(date)});
  }

  // Get couple data stream
  Stream<DocumentSnapshot> getCoupleStream(String coupleId) {
    return _db.collection(_couplesCollection).doc(coupleId).snapshots();
  }

  // Get partner's name
  Future<String?> getPartnerName(String coupleId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    try {
      // Get couple document
      final coupleDoc = await _db.collection(_couplesCollection).doc(coupleId).get();
      if (!coupleDoc.exists) return null;

      final data = coupleDoc.data() as Map<String, dynamic>;

      // Identify partner's ID
      String partnerId;
      if (data['userA'] == currentUser.uid) {
        partnerId = data['userB'];
      } else {
        partnerId = data['userA'];
      }

      // Search for partner's name with the ID
      final userDoc = await _db.collection(_usersCollection).doc(partnerId).get();
      if (userDoc.exists) {
        return userDoc.data()!['name'] as String?;
      }
    } catch (e) {
      print("Error getting partner name: $e");
    }
    return null;
  }

  // Update user's name
  Future<void> updateUserName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Update in Firebase Auth
    await user.updateDisplayName(newName);

    // Update in Firestore
    await _db.collection(_usersCollection).doc(user.uid).update({'name': newName});
  }
}
