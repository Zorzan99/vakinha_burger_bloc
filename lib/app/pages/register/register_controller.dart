import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:vakinha_burger/app/pages/register/register_state.dart';
import 'package:vakinha_burger/app/repositories/auth/auth_repository.dart';

class RegisterController extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterController(this._authRepository) : super(RegisterState.inital());

  Future<void> register(String name, String email, String password) async {
    try {
      emit(state.copyWith(status: RegisterStateStatus.register));
      await _authRepository.register(name, email, password);
      emit(state.copyWith(status: RegisterStateStatus.success));
    } catch (e, s) {
      log('Erro ao registrar usuário', error: e, stackTrace: s);
      emit(state.copyWith(status: RegisterStateStatus.error));
    }
  }
}
