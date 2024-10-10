import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, User>> signUpWithEmailPassword(
      {required String email, required String name, required String password});

  Future<Either<Failures, User>> loginWithEmailPassword(
      {required String email, required String password});

  Future<Either<Failures, User>> getCurrentUser();
}
