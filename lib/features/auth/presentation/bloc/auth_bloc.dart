import 'package:blogger/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogger/core/usecase/usecase.dart';
import 'package:blogger/core/common/entities/user.dart';
import 'package:blogger/features/auth/domain/usecase/current_user.dart';
import 'package:blogger/features/auth/domain/usecase/user_login.dart';
import 'package:blogger/features/auth/domain/usecase/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignupUsecase _userSignupUsecase;
  final UserLoginUsecase _userLoginUsecase;
  final CurrentUserUsecase _currentUserUsecase;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignupUsecase userSignUpUsecase,
    required UserLoginUsecase userLoginUsecase,
    required CurrentUserUsecase currentUserUsecase,
    required AppUserCubit appUserCubit,
  })  : _userSignupUsecase = userSignUpUsecase,
        _userLoginUsecase = userLoginUsecase,
        _currentUserUsecase = currentUserUsecase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignupUsecase(UserSignupParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));
    res.fold((l) {
      emit(AuthFailure(l.message));
    }, (user) => _emitAuthSuccess(user, emit));
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLoginUsecase(UserLoginParams(
      password: event.password,
      email: event.email,
    ));
    res.fold((l) {
      emit(AuthFailure(l.message));
    }, (user) => _emitAuthSuccess(user, emit));
  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final result = await _currentUserUsecase(NoParams());
    result.fold((l) {
      emit(
        AuthFailure(l.message),
      );
    }, (r) => _emitAuthSuccess(r, emit));
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
