import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'collection_pokemon_serie_event.dart';
part 'collection_pokemon_serie_state.dart';

class CollectionPokemonSerieBloc
    extends Bloc<CollectionPokemonSerieEvent, CollectionPokemonSerieState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  CollectionPokemonSerieBloc({required this.collectionPokemonRepository})
    : super(CollectionPokemonSerieInitial()) {
    on<CollectionPokemonGetSeriesEvent>(_onCollectionPokemonGetSeriesEvent);
  }

  Future<void> _onCollectionPokemonGetSeriesEvent(
    CollectionPokemonGetSeriesEvent event,
    Emitter<CollectionPokemonSerieState> emit,
  ) async {
    try {
      emit(CollectionPokemonSerieLoading());
      List<PokemonSerie> series =
          await collectionPokemonRepository.getSeriesWithSets();
      emit(CollectionPokemonSeriesGet(series: series));
    } catch (e) {
      emit(CollectionPokemonSerieError(message: e.toString()));
    }
  }
}
