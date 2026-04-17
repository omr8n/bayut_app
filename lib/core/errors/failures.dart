import 'package:test_graduation/core/language/lang_keys.dart';

abstract class Failure {
  final String message;
  final String? extra;
  Failure(this.message, {this.extra});
}

class ServerFailure extends Failure {
  ServerFailure(super.message, {super.extra});
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = LangKeys.networkRequestFailed]);
}
