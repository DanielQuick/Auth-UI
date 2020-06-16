import 'package:auth_ui/auth_controller.dart';
import 'package:auth_ui/pages/enter_email_page.dart';
import 'package:flutter/material.dart';

class AuthUI extends StatefulWidget {
  final void Function(BuildContext) onLogin;
  final AuthController authController;
  final Widget header;
  final Color signUpButtonColor;
  final BorderSide logInButtonBorder;
  final Color signUpButtonTextColor;
  final Color logInButtonTextColor;
  final Widget aboveAuthButtons;
  final Widget belowAuthButtons;
  const AuthUI(
      {this.onLogin,
      this.authController,
      this.header = const Text(
        "AppName",
      ),
      this.signUpButtonColor = Colors.blue,
      this.logInButtonBorder = const BorderSide(color: Colors.grey),
      this.signUpButtonTextColor,
      this.logInButtonTextColor,
      this.aboveAuthButtons = const SizedBox(),
      this.belowAuthButtons = const SizedBox(),
      Key key})
      : super(key: key);

  @override
  _AuthUIState createState() => _AuthUIState();
}

class _AuthUIState extends State<AuthUI> {
  Widget _body;

  @override
  void initState() {
    super.initState();

    _body = Container();

    if (widget.authController != null) {
      widget.authController.initialize(onInitialize: (isSignedIn) {
        if (isSignedIn) {
          widget.onLogin(context);
        } else {
          setState(() {
            _body = _getMainBody();
          });
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body,
    );
  }

  Widget _getMainBody() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 128),
            child: Align(
              alignment: Alignment.topCenter,
              child: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Theme.of(context).primaryColor),
                child: widget.header,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  widget.aboveAuthButtons,
                  Container(
                    width: 250,
                    child: FlatButton(
                      color: widget.signUpButtonColor,
                      textColor: widget.signUpButtonTextColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterEmailPage(
                                    onLogin: widget.onLogin,
                                    authController: widget.authController,
                                    isLogin: false,
                                  ),
                              fullscreenDialog: true),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 250,
                    child: OutlineButton(
                      borderSide: widget.logInButtonBorder,
                      textColor: widget.logInButtonTextColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterEmailPage(
                                    onLogin: widget.onLogin,
                                    authController: widget.authController,
                                    isLogin: true,
                                  ),
                              fullscreenDialog: true),
                        );
                      },
                      child: Text("Log In"),
                    ),
                  ),
                  widget.belowAuthButtons,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
