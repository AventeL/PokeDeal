import 'package:get_it/get_it.dart';
import 'package:pokedeal/features/Authentication/data/authentication_data_source.dart';
import 'package:pokedeal/features/Authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/Authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/Authentication/presentation/bloc/authentication_bloc.dart';

final GetIt getIt = GetIt.I;

Future<void> initInjectionDependencies() async {
  initExternal();
  initDataSource();
  initRepository();
  initBloc();
}

void initBloc() {
  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(
      authenticationRepository: getIt<AuthenticationRepository>(),
    ),
  );
}

void initRepository() {
  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(
      authenticationDataSource: getIt<IAuthenticationDataSource>(),
    ),
  );
}

void initDataSource() {
  getIt.registerLazySingleton<IAuthenticationDataSource>(
    () => AuthenticationDataSource(),
  );
}

void initExternal() {}
