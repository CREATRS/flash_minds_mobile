import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/utils/validators.dart';
import 'package:flash_minds/widgets/components/app_icon.dart';
import 'package:flash_minds/widgets/components/button.dart';

class Register extends StatefulWidget {
  const Register(this.pageController, {super.key});

  final PageController pageController;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthService auth = Get.find<AuthService>();
  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPasswordController = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height - 48,
            child: Column(
              children: [
                const Spacer(flex: 4),
                const AppIcon(),
                const Spacer(),
                TextFormField(
                  controller: nameController,
                  decoration: inputDecoration.copyWith(hintText: 'Name'),
                  validator: (value) => lenghtValidator(value, 3),
                ),
                const SizedBox(height: 12),
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
                TextFormField(
                  controller: passwordController,
                  decoration: inputDecoration.copyWith(hintText: 'Password'),
                  validator: (value) => lenghtValidator(value, 6),
                  obscureText: true,
                  onChanged: (value) {
                    if (value.length > 5 &&
                        buttonController.currentState == ButtonState.error) {
                      buttonController.reset();
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration:
                      inputDecoration.copyWith(hintText: 'Confirm Password'),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                  obscureText: true,
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
                  text: 'Register',
                  controller: buttonController,
                  onPressed: () async {
                    setState(() {
                      error = '';
                    });
                    if (formKey.currentState!.validate()) {
                      String? response = await auth.register(
                        name: nameController.text,
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
                const Spacer(flex: 4),
                TextButton(
                  onPressed: () => widget.pageController
                      .previousPage(duration: duration, curve: curve),
                  child: const Text('Already have an account? Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
