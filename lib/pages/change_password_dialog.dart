import 'package:auth_ui/auth_controller.dart';
import 'package:auth_ui/pages/auth_ui.dart';
import 'package:auth_ui/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

class ChangePasswordDialog extends StatefulWidget {
  final AuthController authController;
  final BuildContext context;
  ChangePasswordDialog({this.authController, this.context, Key key}) : super(key: key);

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  String _currentPassword = "";
  String _proposedPassword = "";

  FocusNode _currentNode = FocusNode();
  FocusNode _proposedNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Change Password"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PasswordField(
              focusNode: _currentNode,
              autofocus: true,
              onChanged: (value) {
                _currentPassword = value;
              },
              onSubmit: () {
                _proposedNode.requestFocus();
              },
              hintText: "Current Password",
            ),
            PasswordField(
              focusNode: _proposedNode,
              onChanged: (value) {
                _proposedPassword = value;
              },
              hintText: "New Password",
              onSubmit: () {
                Navigator.pop(context);
                _request(widget.context);
              },
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            _request(widget.context);
          },
          child: Text("Request"),
        ),
      ],
    );
  }

  _request(BuildContext context) {
    widget.authController.changePassword(
          currentPassword: _currentPassword,
          proposedPassword: _proposedPassword,
          onSuccess: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Password Updated"),
                  content: Text("Your password has been successfully changed"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"),
                    )
                  ],
                );
              },
            );
          },
          onError: (error) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(_getChangePasswordErrorTitle(error)),
                  content: Text(_getChangePasswordErrorMessage(error)),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Ok"),
                    )
                  ],
                );
              },
            );
          },
        );
  }

  String _getChangePasswordErrorTitle(String error) {
    String value;

    switch (error) {
      case "ChangePasswordError.passwordLength":
      case "ChangePasswordError.passwordUppercase":
      case "ChangePasswordError.passwordLowercase":
      case "ChangePasswordError.passwordNumeric":
      case "ChangePasswordError.passwordSymbol":
        value = "Invalid Proposed Password";
        break;
      case "ChangePasswordError.incorrectPassword":
        value = "Invalid Password";
        break;
      default:
        value = error;
    }

    return value;
  }

  String _getChangePasswordErrorMessage(String error) {
    String value;

    switch (error) {
      case "ChangePasswordError.passwordLength":
        value = "Your new password must be at least 8 characters in length.";
        break;
      case "ChangePasswordError.passwordUppercase":
        value = "Your new password must include at least 1 uppercase character.";
        break;
      case "ChangePasswordError.passwordLowercase":
        value = "Your new password must include at least 1 lowercase character.";
        break;
      case "ChangePasswordError.passwordNumeric":
        value = "Your new password must include at least 1 number.";
        break;
      case "ChangePasswordError.passwordSymbol":
        value = "Your new password must include at least 1 symbol.";
        break;
      case "ChangePasswordError.incorrectPassword":
        value = "Your current password was incorrect";
        break;
      default:
        value = error;
    }

    return value;
  }
}
