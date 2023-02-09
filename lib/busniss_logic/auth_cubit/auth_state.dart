abstract class AuthState{}

class AuthInitial extends AuthState{}

class LoginSuccess extends AuthState{}

class LoginLoading extends AuthState{}

class LoginFailure extends AuthState{}

class RegisterSuccess extends AuthState{}

class RegisterLoading extends AuthState{}

class RegisterFailure extends AuthState{
  String errorMsg;
  RegisterFailure({required this.errorMsg});


}