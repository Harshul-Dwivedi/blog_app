// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/core/common/entities/user.dart';
import 'package:blogger/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignupUsecase implements Usecase<User, UserSignupParams> {
  final AuthRepository authRepository;

  UserSignupUsecase(this.authRepository);
  @override
  Future<Either<Failures, User>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassword(
      email: params.email,
      name: params.name,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String email;
  final String password;
  final String name;
  UserSignupParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
