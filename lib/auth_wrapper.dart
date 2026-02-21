import 'package:flutter/material.dart';
import 'package:flutter_application_2/login.dart';
import 'package:flutter_application_2/main_home_wrapper.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;

  void updateAuth(bool status) {
    setState(() {
      isLoggedIn = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return MainWrapper(onLogout: () => updateAuth(false));
    } else {
      return PremiumLoginScreen(onLogin: () => updateAuth(true));
    }
  }
}
