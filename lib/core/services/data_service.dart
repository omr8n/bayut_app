abstract class DatabaseService {
  Future<String> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });

  Future<dynamic> getData({
    required String path,
    Map<String, dynamic>? query,
    String? documentId,
  });

  Future<List<Map<String, dynamic>>> getCollectionDocuments({
    required String path,
    String? whereField,
    dynamic isEqualTo,
  });

  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  });

  Stream<List<Map<String, dynamic>>> streamData({
    required String path,
    String? whereField,
    dynamic isEqualTo,
  });

  Stream<Map<String, dynamic>?> streamDocument({
    required String path,
    required String documentId,
  });

  Future<List<Map<String, dynamic>>> searchDocuments({
    required String path,
    required String field,
    required String query,
  });

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    required String documentId,
  });

  Future<void> setData({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteData({required String path, required String documentId});

  Future<int> countDocuments({
    required String path,
    String? whereField,
    dynamic isEqualTo,
  });

  Future<List<Map<String, dynamic>>> getPaginatedCollection({
    required String path,
    required int limit,
    dynamic lastDocument,
    String? orderByField,
    bool descending = false,
  });
}
