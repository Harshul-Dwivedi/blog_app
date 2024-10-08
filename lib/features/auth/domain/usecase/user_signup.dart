// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignupUsecase implements Usecase<String, UserSignupParams> {
  final AuthRepository authRepository;

  UserSignupUsecase(this.authRepository);
  @override
  Future<Either<Failures, String>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassword(
        email: params.name, name: params.email, password: params.password);
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
