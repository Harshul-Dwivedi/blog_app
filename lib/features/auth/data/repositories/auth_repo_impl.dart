import 'package:blogger/core/constants/constants.dart';
import 'package:blogger/core/error/exception.dart';
import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/network/connection_checker.dart';
import 'package:blogger/features/auth/data/models/user_model.dart';
import 'package:blogger/features/auth/data/sources/auth_remote_datasource.dart';
import 'package:blogger/core/common/entities/user.dart';
import 'package:blogger/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.remoteDatasource, this.connectionChecker);

  @override
  Future<Either<Failures, User>> getCurrentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDatasource.currentUserSession;
        if (session == null) {
          return left(Failures('User is not logged in!'));
        }
        return right(UserModel(
            email: session.user.email ?? "", id: session.user.id, name: ''));
      }
      final user = await remoteDatasource.getCurrentUserData();
      if (user == null) {
        return left(Failures("User not logged in!"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(() async => await remoteDatasource.loginWithEmailPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    return _getUser(() async => await remoteDatasource.signUpWithEmailPassword(
          email: email,
          password: password,
          name: name,
        ));
  }

  // Move _getUser inside the class
  Future<Either<Failures, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failures(Constants.noConnectionErrorMessage));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
