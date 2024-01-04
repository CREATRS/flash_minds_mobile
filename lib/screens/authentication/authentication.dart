import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';
import 'reset_password.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  PageController pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ResetPassword(pageController),
          Login(pageController),
          Register(pageController),
        ],
      ),
    );
  }
}
