import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'data_service.dart';

class FireStoreService implements DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
    bool forFirestore = true, // 🔥 جعلناها true افتراضياً لرفع العقارات
  }) async {
    try {
      if (documentId != null) {
        await firestore.collection(path).doc(documentId).set(data);
        return documentId;
      } else {
        final docRef = await firestore.collection(path).add(data);
        return docRef.id;
      }
    } catch (e) {
      log("🔥 Firestore Error in addData: $e");
      rethrow;
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> streamData({
    required String path,
    String? whereField,
    dynamic isEqualTo,
  }) {
    Query<Map<String, dynamic>> queryRef = firestore.collection(path);

    if (whereField != null && isEqualTo != null) {
      queryRef = queryRef.where(whereField, isEqualTo: isEqualTo);
    }

    return queryRef.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? documentId,
    Map<String, dynamic>? query,
  }) async {
    if (documentId != null) {
      final data = await firestore.collection(path).doc(documentId).get();
      return data.data();
    } else {
      Query<Map<String, dynamic>> ref = firestore.collection(path);

      if (query != null) {
        if (query['orderBy'] != null) {
          ref = ref.orderBy(
            query['orderBy'],
            descending: query['descending'] ?? false,
          );
        }
        if (query['limit'] != null) {
          ref = ref.limit(query['limit']);
        }
      }

      final result = await ref.get();
      return result.docs.map((e) => e.data()).toList();
    }
  }

  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  getCollectionDocuments({
    required String path,
    String? whereField,
    dynamic isEqualTo,
  }) async {
    Query<Map<String, dynamic>> ref = firestore.collection(path);

    if (whereField != null && isEqualTo != null) {
      ref = ref.where(whereField, isEqualTo: isEqualTo);
    }

    final snapshot = await ref.get();
    return snapshot.docs;
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    final doc = await firestore.collection(path).doc(documentId).get();
    return doc.exists;
  }

  @override
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    if (documentId.isEmpty) {
      throw ArgumentError('Document ID is required for update');
    }
    await firestore.collection(path).doc(documentId).update(data);
    log('Document with ID $documentId updated successfully');
  }

  @override
  Future<void> setData({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await firestore.collection(collectionPath).doc(documentId).set(data);
    log('Document with ID $documentId set successfully in $collectionPath');
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    if (documentId.isEmpty) {
      throw ArgumentError('Document ID is required for delete');
    }
    await firestore.collection(path).doc(documentId).delete();
    log('Document with ID $documentId deleted successfully from $path');
  }
}
