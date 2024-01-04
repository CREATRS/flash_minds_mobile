import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/utils/validators.dart';
import 'package:flash_minds/widgets/components/app_icon.dart';
import 'package:flash_minds/widgets/components/button.dart';

class Login extends StatefulWidget {
  const Login(this.pageController, {super.key});

  final PageController pageController;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService auth = Get.find<AuthService>();
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController =
          TextEditingController(text: 'user@example.com'),
      passwordController = TextEditingController(text: 'password123');
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 8),
            const AppIcon(),
            const Spacer(flex: 2),
            TextFormField(
              controller: emailController,
              decoration: inputDecoration.copyWith(hintText: 'Email'),
              validator: emailValidator,
              onChanged: (value) {
                if (value.length > 5 &&
                    buttonController.currentState == ButtonState.error) {
                  buttonController.reset();
                }
              },
            ),
            const Spacer(),
            TextFormField(
              controller: passwordController,
              decoration: inputDecoration.copyWith(hintText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                if (value.length > 5 &&
                    buttonController.currentState == ButtonState.error) {
                  buttonController.reset();
                }
              },
            ),
            TextButton(
              onPressed: () => widget.pageController
                  .previousPage(duration: duration, curve: curve),
              child: const Text('Forgot password?', style: TextStyles.pMedium),
            ),
            const Spacer(),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            const Spacer(flex: 2),
            Button(
              text: 'Sign in',
              controller: buttonController,
              onPressed: () async {
                setState(() {
                  error = '';
                });
                if (formKey.currentState!.validate()) {
                  buttonController.start();
                  String? response = await auth.login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  if (response == null) {
                    buttonController.success();
                  } else {
                    setState(() {
                      error = response;
                    });
                    buttonController.error();
                    3.seconds.delay(() => buttonController.reset());
                  }
                } else {
                  buttonController.error();
                  3.seconds.delay(() => buttonController.reset());
                }
              },
            ),
            const Spacer(flex: 8),
            TextButton(
              onPressed: () => widget.pageController
                  .nextPage(duration: duration, curve: curve),
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyles.pMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
