import 'package:mockito/annotations.dart';
import 'package:pokedeal/features/authentication/data/authentication_data_source_interface.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/collection/data/collection_pokemon_data_source_interface.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';
import 'package:pokedeal/features/collection/presentation/bloc/card_bloc/collection_pokemon_card_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/serie_bloc/collection_pokemon_serie_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/set_bloc/collection_pokemon_set_bloc.dart';
import 'package:pokedeal/features/trade/data/trade_data_source_interface.dart';
import 'package:pokedeal/features/trade/domain/repository/trade_repository.dart';
import 'package:pokedeal/features/trade/presentation/bloc/trade_bloc.dart';
import 'package:pokedeal/features/collection/presentation/bloc/user_collection/user_collection_bloc.dart';
import 'package:pokedeal/features/profile/data/profile_data_source_interface.dart';
import 'package:pokedeal/features/profile/domain/repository/profile_repository.dart';
import 'package:pokedeal/features/profile/presentation/bloc/profile_bloc.dart';

//Bloc
@GenerateNiceMocks([
  MockSpec<AuthenticationBloc>(),
  MockSpec<CollectionPokemonSerieBloc>(),
  MockSpec<CollectionPokemonSetBloc>(),
  MockSpec<CollectionPokemonCardBloc>(),
  MockSpec<TradeBloc>(),
  MockSpec<ProfileBloc>(),
  MockSpec<UserCollectionBloc>(),
])
//Repository
@GenerateNiceMocks([
  MockSpec<AuthenticationRepository>(),
  MockSpec<CollectionPokemonRepository>(),
  MockSpec<TradeRepository>(),
  MockSpec<ProfileRepository>(),
])
//DataSource
@GenerateNiceMocks([
  MockSpec<IAuthenticationDataSource>(),
  MockSpec<ICollectionPokemonDataSource>(),
  MockSpec<ITradeDataSource>(),
  MockSpec<IProfileDataSource>(),
])
main() {}
