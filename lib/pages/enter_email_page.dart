import 'package:auth_ui/auth_controller.dart';
import 'package:auth_ui/pages/sign_in_page.dart';
import 'package:auth_ui/pages/sign_up_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EnterEmailPage extends StatefulWidget {
  final void Function(BuildContext) onLogin;
  final AuthController authController;
  final bool isLogin;

  EnterEmailPage(
      {this.onLogin, this.isLogin = true, this.authController, Key key})
      : super(key: key);

  @override
  _EnterEmailPageState createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  String _email = "";

  FocusNode _focusNode = FocusNode();

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
                  Text(
                    "What's your email?",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  EmailField(
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    focusNode: _focusNode,
                    autofocus: true,
                    onSubmit: _continue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _email.length > 0
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

  _continue() {
    if (!EmailValidator.validate(_email)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid email address"),
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

    if (widget.isLogin) {
      widget.authController.signIn(
        username: _email,
        password: "",
        onSuccess: () {
          if (widget.onLogin != null) {
            widget.onLogin(context);
          }
        },
        onError: (error) {
          print(error);
          if (error == "SignInError.userNotFound") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("No account found"),
                  content: Text(
                      "This email is not associated with an account. Try signing up first!"),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(
                    onLogin: widget.onLogin,
                    authController: widget.authController,
                    email: _email),
              ),
            );
          }
        },
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(
                onLogin: widget.onLogin,
                authController: widget.authController,
                email: _email),
          ));
    }
  }
}

class EmailField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final Function onSubmit;
  final bool autofocus;
  const EmailField(
      {this.focusNode,
      this.autofocus = false,
      this.onSubmit,
      this.onChanged,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Email",
        ),
        onChanged: onChanged,
        keyboardType: TextInputType.emailAddress,
        focusNode: focusNode,
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
