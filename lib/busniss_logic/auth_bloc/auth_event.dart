abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  String email;
  String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  String passwordController;
  String emailController;
  String confirmPassword;
  String userNameController;
  String phone;

  RegisterEvent(
      {required this.phone,
      required this.confirmPassword,
      required this.passwordController,
      required this.emailController,
      required this.userNameController});
}
