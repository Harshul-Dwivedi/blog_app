import 'package:blogger/core/error/failures.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/core/common/entities/user.dart';
import 'package:blogger/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUserUsecase implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUserUsecase(this.authRepository);
  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}
