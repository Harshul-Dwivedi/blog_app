// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/core/common/entities/user.dart';
import 'package:blogger/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLoginUsecase implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;
  const UserLoginUsecase(this.authRepository);

  @override
  Future<Either<Failures, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
