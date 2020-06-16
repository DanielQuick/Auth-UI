class AuthController {
  initialize({Function(bool) onInitialize}) {}
  signUp({
    String username,
    String password,
    Map attributes,
    Function onSuccess,
    Function(String) onError,
  }) {}
  signIn({
    String username,
    String password,
    Function onSuccess,
    Function(String) onError,
  }) {}
  forgotPassword({
    String username,
    Function onSuccess,
    Function(String) onError,
  }) {}
  forgotPasswordConfirm({
    String username,
    String verificationCode,
    String password,
    Function onSuccess,
    Function(String) onError,
  }) {}
  changePassword({
    String currentPassword,
    String proposedPassword,
    Function onSuccess,
    Function(String) onError,
  }) {}
  resendVerification({
    String username,
    Function onResult,
    Function(String) onError,
  }) {}
}
