import 'package:mockito/annotations.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';

//Bloc
@GenerateNiceMocks([MockSpec<AuthenticationBloc>()])
//Repository
@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
//DataSource
@GenerateNiceMocks([MockSpec<IAuthenticationDataSource>()])
main() {}
