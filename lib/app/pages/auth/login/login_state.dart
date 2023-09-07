// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'login_state.g.dart';

@match
enum LoginStatus { inital, login, success, loginError, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  const LoginState({
    required this.status,
    this.errorMessage,
  });
  const LoginState.inital()
      : status = LoginStatus.inital,
        errorMessage = null;

  @override
  List<Object?> get props => [status, errorMessage];

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
