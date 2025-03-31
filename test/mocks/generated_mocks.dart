import 'package:mockito/annotations.dart';
import 'package:pokedeal/features/Authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/Authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/Authentication/presentation/bloc/authentication_bloc.dart';

//Bloc
@GenerateNiceMocks([MockSpec<AuthenticationBloc>()])
//Repository
@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
//DataSource
@GenerateNiceMocks([MockSpec<IAuthenticationDataSource>()])
main() {}
