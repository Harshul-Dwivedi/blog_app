import 'package:blogger/features/auth/domain/usecase/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignupUsecase _userSignupUsecase;
  AuthBloc({required UserSignupUsecase usersSignUpUsecase})
      : _userSignupUsecase = usersSignUpUsecase,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final res = await _userSignupUsecase(UserSignupParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ));
      res.fold((l) {
        emit(AuthFailure(l.message));
      }, (uid) {
        emit(AuthSuccess(uid));
      });
    });
  }
}
