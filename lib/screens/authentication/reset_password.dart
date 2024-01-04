import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/utils/validators.dart';
import 'package:flash_minds/widgets/components/app_icon.dart';
import 'package:flash_minds/widgets/components/button.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword(this.pageController, {super.key});

  final PageController pageController;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  AuthService auth = Get.find<AuthService>();
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController =
      TextEditingController(text: 'beykelhofm@wikispaces.com');
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
            const Spacer(flex: 4),
            const AppIcon(),
            const Spacer(),
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
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
            const Spacer(),
            Button(
              text: 'Send reset email',
              controller: buttonController,
              onPressed: () async {
                setState(() {
                  error = '';
                });
                if (formKey.currentState!.validate()) {
                  String? response = await auth.login(
                    email: emailController.text,
                    password: '',
                  );
                  if (response == null) {
                    buttonController.success();
                  } else {
                    setState(() {
                      error = response;
                    });
                    buttonController.error();
                    3.delay(() => buttonController.reset());
                  }
                } else {
                  buttonController.error();
                  Future.delayed(
                    const Duration(seconds: 3),
                    () => buttonController.reset(),
                  );
                }
              },
            ),
            const Spacer(flex: 4),
            TextButton(
              onPressed: () => widget.pageController
                  .nextPage(duration: duration, curve: curve),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
