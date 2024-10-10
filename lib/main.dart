import 'package:blogger/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogger/core/secrets/supabase_secrets.dart';
import 'package:blogger/core/theme/theme.dart';
import 'package:blogger/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:blogger/features/auth/data/sources/auth_remote_datasource.dart';
import 'package:blogger/features/auth/domain/usecase/user_signup.dart';
import 'package:blogger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogger/features/auth/presentation/pages/login_page.dart';
import 'package:blogger/features/auth/presentation/pages/signup_page.dart';
import 'package:blogger/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogger/features/blog/presentation/pages/blog_pages.dart';
import 'package:blogger/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<BlogBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blogger',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return BlogPages();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
