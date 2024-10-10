part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
      url: SupabaseSecrets.supabaseUrl,
      anonKey: SupabaseSecrets.supabaseAnonKey);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(InternetConnection()));

  ///singleton cause we need a single point of connection with d.b,since
  ///this deals with user authentication multiple inst. might lead to
  ///inconsistent states/
}

void _initAuth() {
  ///factory is used cause we need a fresh instance every time authentication
  ///is used (login, logout, email, etc). Also to avoid multiple sessions like one
  ///user trying to login while other is already logged.
  serviceLocator.registerFactory<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignupUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUpUsecase: serviceLocator(),
      userLoginUsecase: serviceLocator(),
      currentUserUsecase: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CurrentUserUsecase(
      serviceLocator(),
    ),
  );
}

void _initBlog() {
  //datasource
  serviceLocator
    ..registerFactory<BlogRemoteDatasource>(() => BlogRemoteDatasourceImpl(
          serviceLocator(),
        ))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))
    //repository
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ))
    //usecase
    ..registerFactory(() => UploadBlogUsecase(serviceLocator()))
    ..registerFactory(() => GetAllBlogsUsecase(serviceLocator()))
    ..registerLazySingleton(() => BlogBloc(
        uploadBlogUsecase: serviceLocator(),
        getAllBlogUsecase: serviceLocator()));
}
