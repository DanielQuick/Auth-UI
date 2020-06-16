import 'package:auth_ui/auth_controller.dart';
import 'package:auth_ui/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final void Function(BuildContext) onLogin;
  final AuthController authController;
  final String email;

  SignUpPage({this.onLogin, this.email = "", this.authController, Key key})
      : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _firstName;
  String _lastName;
  String _password;
  String _passwordConfirm;

  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                  ).copyWith(
                    top: 64,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Welcome!",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Text(
                          "Let's create your account.",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      SizedBox(height: 64),
                      FormCategory(
                        label: "What's your name?",
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: NameField(
                                onChanged: (value) {
                                  setState(() {
                                    _firstName = value;
                                  });
                                },
                                hintText: "First Name",
                                focusNode: _firstNameFocusNode,
                                autofocus: true,
                                onSubmit: () {
                                  _lastNameFocusNode.requestFocus();
                                },
                              ),
                            ),
                            SizedBox(
                              width: 32,
                            ),
                            Flexible(
                              flex: 1,
                              child: NameField(
                                onChanged: (value) {
                                  setState(() {
                                    _lastName = value;
                                  });
                                },
                                hintText: "Last Name",
                                focusNode: _lastNameFocusNode,
                                onSubmit: () {
                                  _passwordFocusNode.requestFocus();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      FormCategory(
                        label: "Create your password",
                        child: Column(
                          children: <Widget>[
                            PasswordField(
                              onChanged: (value) {
                                _password = value;
                              },
                              focusNode: _passwordFocusNode,
                              onSubmit: () {
                                _confirmPasswordFocusNode.requestFocus();
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            PasswordField(
                              hintText: "Confirm Password",
                              onChanged: (value) {
                                _passwordConfirm = value;
                              },
                              focusNode: _confirmPasswordFocusNode,
                              onSubmit: _continue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 64,
                ),
                Center(
                  child: Container(
                    width: 200,
                    child: RaisedButton(
                      child: Text("Create Account"),
                      textColor: Theme.of(context).primaryColorBrightness ==
                              Brightness.light
                          ? Colors.black
                          : Colors.white,
                      onPressed: _continue,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 32,
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: BackButton(),
            ),
          ],
        ),
      ),
    );
  }

  _continue() {
    if (_password != _passwordConfirm) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Passwords do not match"),
            actions: <Widget>[
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
      return;
    }

    if (widget.authController != null) {
      widget.authController.signUp(
          username: widget.email,
          password: _password,
          attributes: {
            "first_name": _firstName,
            "last_name": _lastName,
          },
          onSuccess: () async {
            bool result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Account Created"),
                      content: Text(
                          "An email has been sent to verify your account. Verify your email, then proceed to log in."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    );
                  },
                ) ??
                true;

            if (result) {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            }
          },
          onError: (error) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(_getSignUpErrorTitle(error)),
                  content: Text(_getSignUpErrorMessage(error)),
                  actions: <Widget>[
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
            print(error);
          });
    } else {
      if (widget.onLogin != null) {
        widget.onLogin(context);
      }
    }
  }

  String _getSignUpErrorTitle(String error) {
    String value;

    switch (error) {
      case "SignUpError.passwordLength":
      case "SignUpError.passwordUppercase":
      case "SignUpError.passwordLowercase":
      case "SignUpError.passwordNumeric":
      case "SignUpError.passwordSymbol":
        value = "Invalid Password";
        break;
      case "SignUpError.attributeRequired":
        value = "Missing Information";
        break;
      case "SignUpError.userExists":
        value = "Account Exists";
        break;
      case "SignUpError.usernameLength":
      case "SignUpError.emailInvalid":
        value = "Invalid Email";
        break;
      default:
        value = error;
    }

    return value;
  }

  String _getSignUpErrorMessage(String error) {
    String value;

    switch (error) {
      case "SignUpError.passwordLength":
        value = "Your password must be at least 8 characters in length.";
        break;
      case "SignUpError.passwordUppercase":
        value = "Your password must include at least 1 uppercase character.";
        break;
      case "SignUpError.passwordLowercase":
        value = "Your password must include at least 1 lowercase character.";
        break;
      case "SignUpError.passwordNumeric":
        value = "Your password must include at least 1 number.";
        break;
      case "SignUpError.passwordSymbol":
        value = "Your password must include at least 1 symbol.";
        break;
      case "SignUpError.attributeRequired":
        value = "Please fill out all available fields.";
        break;
      case "SignUpError.userExists":
        value = "An account with your email already exists.";
        break;
      case "SignUpError.usernameLength":
      case "SignUpError.emailInvalid":
        value = "The email provided is not valid.";
        break;
      default:
        value = error;
    }

    return value;
  }
}

class FormCategory extends StatelessWidget {
  final String label;
  final Widget child;
  const FormCategory({this.label, this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        child,
      ],
    );
  }
}

class NameField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final FocusNode focusNode;
  final bool autofocus;
  final Function onSubmit;
  const NameField(
      {this.hintText,
      this.autofocus = false,
      this.onSubmit,
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
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        focusNode: focusNode,
        autofocus: autofocus,
        onFieldSubmitted: (value) => onSubmit(),
      ),
    );
  }
}
