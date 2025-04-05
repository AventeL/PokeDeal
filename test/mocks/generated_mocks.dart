import 'package:mockito/annotations.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/collection_pokemon_bloc.dart';

//Bloc
@GenerateNiceMocks([
  MockSpec<AuthenticationBloc>(),
  MockSpec<CollectionPokemonBloc>(),
])
//Repository
@GenerateNiceMocks([
  MockSpec<AuthenticationRepository>(),
  MockSpec<CollectionPokemonRepository>(),
])
//DataSource
@GenerateNiceMocks([
  MockSpec<IAuthenticationDataSource>(),
  MockSpec<ICollectionPokemonDataSource>(),
])
main() {}
