import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokedeal/features/collection/domain/models/pokemon_serie.dart';
import 'package:pokedeal/features/collection/domain/repository/collection_pokemon_repository.dart';

part 'collection_pokemon_event.dart';
part 'collection_pokemon_state.dart';

class CollectionPokemonBloc
    extends Bloc<CollectionPokemonEvent, CollectionPokemonState> {
  final CollectionPokemonRepository collectionPokemonRepository;

  CollectionPokemonBloc({required this.collectionPokemonRepository})
    : super(CollectionPokemonInitial()) {
    on<CollectionPokemonGetSeriesEvent>(_onCollectionPokemonGetSeriesEvent);
  }

  Future<void> _onCollectionPokemonGetSeriesEvent(
    CollectionPokemonGetSeriesEvent event,
    Emitter<CollectionPokemonState> emit,
  ) async {
    try {
      emit(CollectionPokemonLoading());
      List<PokemonSerie> series = await collectionPokemonRepository.getSeries();
      emit(CollectionPokemonSeriesGet(series: series));
    } catch (e) {
      emit(CollectionPokemonError(message: e.toString()));
    }
  }
}
