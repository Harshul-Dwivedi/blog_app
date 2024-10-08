import 'package:blogger/core/secrets/supabase_secrets.dart';
import 'package:blogger/core/theme/theme.dart';
import 'package:blogger/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:blogger/features/auth/data/sources/auth_remote_datasource.dart';
import 'package:blogger/features/auth/domain/usecase/user_signup.dart';
import 'package:blogger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogger/features/auth/presentation/pages/login_page.dart';
import 'package:blogger/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
      url: SupabaseSecrets.supabaseUrl,
      anonKey: SupabaseSecrets.supabaseAnonKey);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => AuthBloc(
          usersSignUpUsecase: UserSignupUsecase(
            AuthRepositoryImpl(
              AuthRemoteDataSourceImpl(supabase.client),
            ),
          ),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blogger',
      theme: AppTheme.darkThemeMode,
      home: LoginPage(),
    );
  }
}
