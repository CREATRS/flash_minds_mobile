import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';

import 'package:flash_minds/utils/constants.dart';
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
  bool showPrivacyPolicyButton = false;

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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedSlide(
            duration: duration,
            offset: Offset(0, showPrivacyPolicyButton ? 0 : 2),
            child: TextButton(
              child: const Text('Privacy policy'),
              onPressed: () => launchUrlString(Urls.privacyPolicy),
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              showPrivacyPolicyButton = !showPrivacyPolicyButton;
            }),
            icon: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 8, height: 72),
        ],
      ),
    );
  }
}
