import 'package:blogger/core/theme/app_pallete.dart';
import 'package:blogger/features/auth/presentation/pages/signup_page.dart';
import 'package:blogger/features/auth/presentation/widgets/auth_field.dart';
import 'package:blogger/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            /// The FormKey is declared inside the build method because every time a rebuild occurs,
            /// a new instance of the FormKey is created, ensuring that no old data or state persists.
            /// This is important when we want a fresh form every time the widget rebuilds,
            /// without retaining any previous input or validation state.

            key: formKey,
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                AuthField(
                  hintText: "Email",
                  textEditingController: emailController,
                ),
                const SizedBox(
                  height: 15,
                ),
                AuthField(
                  // isObscureText: true,
                  hintText: "Password",
                  textEditingController: passwordController,
                ),
                const SizedBox(
                  height: 15,
                ),
                AuthGradientButton(onPressed: () {}, label: "Sign In"),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SignupPage.route());
                  },
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Sign Up",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppPallete.gradient2,
                                    fontWeight: FontWeight.bold,
                                  ))
                        ],
                        text: "Don't have an account ",
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
