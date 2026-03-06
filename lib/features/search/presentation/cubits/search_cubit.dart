import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// State
class SearchState extends Equatable {
  final String searchQuery;
  final bool isSearching;
  final List<dynamic> searchResults;

  const SearchState({
    this.searchQuery = '',
    this.isSearching = false,
    this.searchResults = const [],
  });

  @override
  List<Object?> get props => [searchQuery, isSearching, searchResults];

  SearchState copyWith({
    String? searchQuery,
    bool? isSearching,
    List<dynamic>? searchResults,
  }) {
    return SearchState(
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}

// Cubit
class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query, isSearching: query.isNotEmpty));
    // In a real app, logic for API search would go here.
  }

  void clearSearch() {
    emit(const SearchState());
  }
}
