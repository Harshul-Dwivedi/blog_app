import 'package:blogger/core/error/exception.dart';
import 'package:blogger/core/error/failures.dart';
import 'package:blogger/features/auth/data/sources/auth_remote_datasource.dart';
import 'package:blogger/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  AuthRepositoryImpl(this.remoteDatasource);
  @override
  Future<Either<Failures, String>> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failures, String>> signUpWithEmailPassword(
      {required String email,
      required String name,
      required String password}) async {
    try {
      final userId = await remoteDatasource.signUpWithEmailPassword(
          email: email, password: password, name: name);

      return right(userId);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
