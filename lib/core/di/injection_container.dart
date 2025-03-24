import 'package:get_it/get_it.dart';
import 'package:pokedeal/features/Authentication/data/authentification_data_source.dart';
import 'package:pokedeal/features/Authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/Authentication/presentation/bloc/authentication_bloc.dart';

final GetIt getIt = GetIt.I;

Future<void> initInjectionDependencies() async {
  initBloc();
  initRepository();
  initDataSource();
  initExternal();
}

void initBloc() {
  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(authenticationRepository: getIt()),
  );
}

void initRepository() {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(authentificationDataSource: getIt()),
  );
}

void initDataSource() {
  getIt.registerLazySingleton<AuthentificationDataSource>(
    () => AuthentificationDataSource(),
  );
}

void initExternal() {}
