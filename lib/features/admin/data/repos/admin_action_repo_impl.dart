import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';

class AdminActionRepoImpl implements AdminActionRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> logAction(AdminActionModel action) async {
    try {
      await _firestore
          .collection(BackendEndpoint.adminActions)
          .doc(action.id)
          .set(action.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdminActionModel>>> getActions() async {
    try {
      final snapshot = await _firestore
          .collection(BackendEndpoint.adminActions)
          .orderBy('createdAt', descending: true)
          .get();
      
      final actions = snapshot.docs
          .map((doc) => AdminActionModel.fromJson(doc.data()))
          .toList();
      
      return Right(actions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
