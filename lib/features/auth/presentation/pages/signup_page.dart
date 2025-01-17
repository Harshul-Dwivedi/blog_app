import 'package:blogger/core/common/widgets/loader.dart';
import 'package:blogger/core/theme/app_pallete.dart';
import 'package:blogger/core/utils/show_snackbar.dart';
import 'package:blogger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogger/features/auth/presentation/pages/login_page.dart';
import 'package:blogger/features/auth/presentation/widgets/auth_field.dart';
import 'package:blogger/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:blogger/features/blog/presentation/pages/blog_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (BuildContext context) => const SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CustomLoader();
              } else if (state is AuthSuccess) {
                Navigator.pushAndRemoveUntil(
                    context, BlogPages.route(), (route) => false);
              }
              return Form(
                /// The FormKey is declared inside the build method because every time a rebuild occurs,
                /// a new instance of the FormKey is created, ensuring that no old data or state persists.
                /// This is important when we want a fresh form every time the widget rebuilds,
                /// without retaining any previous input or validation state.

                key: formKey,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthField(
                      hintText: "Name",
                      textEditingController: nameController,
                    ),
                    const SizedBox(
                      height: 15,
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
                    AuthGradientButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthSignUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim()));
                          }
                        },
                        label: "Sign Up"),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          LoginPage.route(),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "Sign In",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppPallete.gradient2,
                                        fontWeight: FontWeight.bold,
                                      ))
                            ],
                            text: "Already have an account ",
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
