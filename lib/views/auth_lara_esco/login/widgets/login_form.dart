import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

import 'package:babysitterapp/controllers/auth_controller.dart';

import 'package:babysitterapp/core/components.dart';
import 'package:babysitterapp/core/constants.dart';
import 'package:babysitterapp/core/helpers.dart';
import 'package:babysitterapp/core/state.dart';

import 'package:babysitterapp/models/models.dart';

import 'package:babysitterapp/views/auth.dart';
import 'package:babysitterapp/views/home.dart';

class LoginForm extends HookConsumerWidget with GlobalStyles {
  LoginForm({super.key});

  final List<InputFieldConfig> loginFields = <InputFieldConfig>[
    const InputFieldConfig(
      label: 'Email',
      type: 'email',
      hintText: 'Enter your email address',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.mail,
    ),
    const InputFieldConfig(
      label: 'Password',
      type: 'password',
      hintText: 'Enter your password',
      obscureText: true,
      prefixIcon: Icons.lock,
    ),
  ];

  void handleSubmit(BuildContext context, WidgetRef ref,
      Map<String, String> formData, ValueNotifier<bool> isLoading) {
    final String email = formData['Email'] ?? '';
    final String password = formData['Password'] ?? '';

    ref.read(authController.notifier).login(
          email: email,
          password: password,
        );
    isLoading.value = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> isLoading = useState(false);

    ref.listen(authController, (AuthState? previous, AuthState next) {
      next.maybeWhen(
        orElse: () => isLoading.value = false,
        authenticated: (UserAccount user) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User Logged In'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          isLoading.value = false;
          goToPage(context, const BottomNavbarView(), 'rightToLeftWithFade');
        },
        unauthenticated: (String? message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message!),
              behavior: SnackBarBehavior.floating,
            ),
          );
          isLoading.value = false;
        },
      );
    });

    return Column(
      children: <Widget>[
        DynamicForm(
          fields: loginFields,
          onSubmit: (Map<String, String> formData) {
            handleSubmit(context, ref, formData, isLoading);
          },
          isLoading: isLoading,
        ),
        const SizedBox(height: GlobalStyles.defaultPadding),
        AlreadyHaveAnAccountCheck(
          press: () {
            goToPage(context, RegisterView(), 'rightToLeftWithFade');
          },
        ),
      ],
    );
  }
}
