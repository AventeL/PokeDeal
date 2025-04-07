import 'package:mockito/annotations.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';

//Bloc
@GenerateNiceMocks([
  MockSpec<AuthenticationBloc>(),
  MockSpec<CollectionPokemonSerieBloc>(),
  MockSpec<CollectionPokemonSetBloc>(),
  MockSpec<CollectionPokemonCardBloc>(),
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
