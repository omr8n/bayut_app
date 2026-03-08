// abstract class DatabaseService {
//   Future<String> addData({
//     required String path,
//     required Map<String, dynamic> data,
//     String? documentId,
//   });
//   Future<dynamic> getData({
//     required String path,

//     Map<String, dynamic>? query,
//     String? docuementId,
//   });

//   Future<bool> checkIfDataExists({
//     required String path,
//     required String docuementId,
//   });

//   Future<void> updateData({
//     required String path,
//     required Map<String, dynamic> data,
//     required String documentId,
//   });
//   Future<void> setData({
//     required String collectionPath,
//     required String documentId,
//     required Map<String, dynamic> data,
//   });
// }

// abstract class DatabaseService {
//   Future<String> addData({
//     required String path,
//     required Map<String, dynamic> data,
//     String? documentId,
//   });

//   Future<dynamic> getData({
//     required String path,
//     Map<String, dynamic>? query,
//     String? documentId,
//   });

//   Future<List<dynamic>> getCollectionDocuments({
//     required String path,
//     String? whereField,
//     dynamic isEqualTo,
//   });

//   Future<bool> checkIfDataExists({
//     required String path,
//     required String documentId,
//   });
//   Stream<dynamic> streamData({
//     required String path,
//     Map<String, dynamic>? query,
//   });

//   Future<void> updateData({
//     required String path,
//     required Map<String, dynamic> data,
//     required String documentId,
//   });

//   Future<void> setData({
//     required String collectionPath,
//     required String documentId,
//     required Map<String, dynamic> data,
//   });
// }

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

  Future<List<dynamic>> getCollectionDocuments({
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
}
