import 'package:auth_ui/auth_controller.dart';
import 'package:auth_ui/widgets/routes/fade_route.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignInPage extends StatefulWidget {
  final void Function(BuildContext) onLogin;
  final AuthController authController;
  final String email;

  SignInPage({this.onLogin, this.authController, this.email, Key key})
      : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _password = "";

  FocusNode _focusNode = FocusNode();

  String _verificationCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: BackButton(),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ).copyWith(
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Welcome back!",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Center(child: Chip(label: Text(widget.email.toLowerCase()))),
                  SizedBox(height: 16),
                  Text(
                    "What's your password?",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PasswordField(
                    onChanged: (value) {
                      _password = value;
                    },
                    focusNode: _focusNode,
                    autofocus: true,
                    onSubmit: () {
                      _continue();
                    },
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    child: FlatButton(
                      onPressed: () {
                        _showForgotPasswordDialog(context);
                      },
                      child: Text(
                        "Forgot password?",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _password.length > 0
          ? Container(
              padding: EdgeInsets.only(bottom: _focusNode.hasFocus ? 0 : 64),
              child: FloatingActionButton(
                onPressed: _continue,
                child: Icon(Icons.arrow_forward),
              ),
            )
          : null,
    );
  }

  _showForgotPasswordDialog(BuildContext context) {
    widget.authController.forgotPassword(
      username: widget.email,
      onSuccess: () {
        showDialog(
          context: context,
          builder: (context) {
            return _forgotPasswordDialog(context);
          },
        );
      },
      onError: (error) {
        print(error);
        if (error == "SignInError.unknown") {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Too Many Attempts"),
                content: Text("Please try again later."),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Email Not Verified"),
                content: Text(
                    "Please verify your email before attempting to change your password."),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget _forgotPasswordDialog(BuildContext context) {
    return Dialog(
      child: Container(
        height: 350,
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Container(),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: Navigator(
                initialRoute: "/",
                onGenerateRoute: (RouteSettings settings) {
                  WidgetBuilder builder;
                  switch (settings.name) {
                    case "/":
                      builder = (BuildContext context) => Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0, bottom: 32),
                                child: Column(
                                  children: [
                                    Text(
                                      "A verification code was sent to ${widget.email}",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "Enter the code below",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: FlatButton(
                                    textColor: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      widget.authController.forgotPassword(
                                        username: widget.email,
                                        onSuccess: () {},
                                        onError: (error) {
                                          print(error);
                                        },
                                      );
                                    },
                                    child: Text("Resend code"),
                                  ),
                                ),
                              ),
                              Container(
                                width: 270,
                                padding: EdgeInsets.only(bottom: 64),
                                child: PinCodeTextField(
                                  autoFocus: true,
                                  backgroundColor:
                                      Theme.of(context).dialogBackgroundColor,
                                  length: 6,
                                  onChanged: (value) {},
                                  onCompleted: (value) {
                                    _verificationCode = value;
                                    Navigator.push(
                                        context,
                                        FadeRoute(
                                            page: _forgotPasswordPageTwo(
                                                context)));
                                  },
                                  autoDismissKeyboard: false,
                                  activeColor:
                                      Theme.of(context).primaryColorLight,
                                  inactiveColor:
                                      Theme.of(context).primaryColorLight,
                                  selectedColor: Theme.of(context).primaryColor,
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  animationType: AnimationType.fade,
                                ),
                              ),
                            ],
                          );
                      break;
                  }
                  return MaterialPageRoute(
                      builder: builder, settings: settings);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _forgotPasswordPageTwo(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 32),
          child: Text(
            "Enter your new password",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: TextField(
            autofocus: true,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "New Password",
            ),
            onChanged: (value) {
              _password = value;
            },
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 32, left: 32, right: 32),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                textColor:
                    Theme.of(context).primaryColorBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                onPressed: () {
                  widget.authController.forgotPasswordConfirm(
                    username: widget.email,
                    verificationCode: _verificationCode,
                    password: _password,
                    onSuccess: () {
                      Navigator.push(context,
                          FadeRoute(page: _forgotPasswordSuccess(context)));
                    },
                    onError: (error) {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: _forgotPasswordError(
                                  context,
                                  _getForgotPasswordConfirmErrorTitle(error),
                                  _getForgotPasswordConfirmErrorMessage(
                                      error))));
                    },
                  );
                },
                child: Text("Change Password"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getForgotPasswordConfirmErrorTitle(String error) {
    String value = "";
    switch (error) {
      case "ConfirmForgotPasswordError.passwordLength":
      case "ConfirmForgotPasswordError.passwordUppercase":
      case "ConfirmForgotPasswordError.passwordLowercase":
      case "ConfirmForgotPasswordError.passwordNumeric":
      case "ConfirmForgotPasswordError.passwordSymbol":
        value = "Invalid Password";
        break;
      case "ConfirmForgotPasswordError.invalidCode":
        value = "Incorrect Verification Code";
        break;
      default:
        value = error;
        break;
    }

    return value;
  }

  String _getForgotPasswordConfirmErrorMessage(String error) {
    String value = "";
    switch (error) {
      case "ConfirmForgotPasswordError.passwordLength":
        value = "Your password must be at least 8 characters in length.";
        break;
      case "ConfirmForgotPasswordError.passwordUppercase":
        value = "Your password must contain at least 1 uppercase character.";
        break;
      case "ConfirmForgotPasswordError.passwordLowercase":
        value = "Your password must contain at least 1 lowercase character.";
        break;
      case "ConfirmForgotPasswordError.passwordNumeric":
        value = "Your password must contain at least 1 number.";
        break;
      case "ConfirmForgotPasswordError.passwordSymbol":
        value = "Your password must contain at least 1 symbol.";
        break;
      case "ConfirmForgotPasswordError.invalidCode":
        value = "Your verification code was incorrect. Please try again.";
        break;
      default:
        value = error;
        break;
    }

    return value;
  }

  _forgotPasswordError(BuildContext context, String title, String description) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 32),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            description,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 32, left: 32, right: 32),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                textColor:
                    Theme.of(context).primaryColorBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                onPressed: () {
                  bool codeWrong = title.toLowerCase().contains("code");
                  if (codeWrong) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text("Try Again"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _forgotPasswordSuccess(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 32),
          child: Text(
            "Password Reset Successful",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Your password has been changed and you're all ready to log in!",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 32, left: 32, right: 32),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                textColor:
                    Theme.of(context).primaryColorBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text("Log In"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _continue() {
    if (widget.authController != null) {
      widget.authController.signIn(
          username: widget.email,
          password: _password,
          onSuccess: () {
            if (widget.onLogin != null) {
              widget.onLogin(context);
            }
          },
          onError: (error) {
            if (error == "SignInError.userAlreadySignedIn") {
              if (widget.onLogin != null) {
                widget.onLogin(context);
              }
              return;
            }
            print(error);
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(_getSignInErrorTitle(error)),
                  content: Text(_getSignInErrorMessage(error)),
                  actions: <Widget>[
                    error == "SignInError.userNotConfirmed"
                        ? FlatButton(
                            child: Text("Resend Verification"),
                            onPressed: () {
                              widget.authController.resendVerification(
                                username: widget.email,
                                onResult: () {},
                                onError: (error) {
                                  print(error);
                                },
                              );
                              Navigator.pop(context);
                            },
                          )
                        : Container(),
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          });
    } else {
      if (widget.onLogin != null) {
        widget.onLogin(context);
      }
    }
  }

  String _getSignInErrorTitle(String error) {
    String value;

    switch (error) {
      case "SignInError.userNotConfirmed":
        value = "Account Not Confirmed";
        break;
      case "SignInError.incorrectUsernameOrPassword":
        value = "Invalid Login";
        break;
      default:
        value = error;
    }

    return value;
  }

  String _getSignInErrorMessage(String error) {
    String value;

    switch (error) {
      case "SignInError.userNotConfirmed":
        value = "You must confirm your account via email before signing in.";
        break;
      case "SignInError.incorrectUsernameOrPassword":
        value = "Your email or password was incorrect.";
        break;
      default:
        value = error;
    }

    return value;
  }
}

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final String hintText;
  final Function onSubmit;
  final bool autofocus;
  const PasswordField(
      {this.hintText = "Password",
      this.onSubmit,
      this.autofocus = false,
      this.focusNode,
      this.onChanged,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
        ),
        onChanged: onChanged,
        focusNode: focusNode,
        obscureText: true,
        autofocus: autofocus,
        onFieldSubmitted: (value) {
          if (onSubmit != null) {
            onSubmit();
          }
        },
      ),
    );
  }
}
