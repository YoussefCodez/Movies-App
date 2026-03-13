import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/browse_cubit.dart';
import '../cubit/browse_state.dart';
import '../widgets/genre_button.dart';
import '../widgets/movie_grid_item.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<BrowseCubit>();
    if (cubit.state is BrowseInitial) {
      cubit.changeGenre(cubit.currentGenre);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 45,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: BrowseCubit.genres.length,
                itemBuilder: (context, index) {
                  final genre = BrowseCubit.genres[index];
                  return BlocBuilder<BrowseCubit, BrowseState>(
                    buildWhen: (previous, current) {
                      if (current is BrowseSuccess) return true;
                      if (current is BrowseLoading) return true;
                      if (current is BrowseError) return true;
                      if (current is BrowseEmpty) return true;
                      return false;
                    },
                    builder: (context, state) {
                      String selectedGenre = context
                          .read<BrowseCubit>()
                          .currentGenre;
                      if (state is BrowseSuccess) {
                        selectedGenre = state.selectedGenre;
                      }
                      if (state is BrowseLoading) {
                        selectedGenre = context
                            .read<BrowseCubit>()
                            .currentGenre;
                      }
                      if (state is BrowseError) {
                        selectedGenre = state.selectedGenre;
                      }
                      if (state is BrowseEmpty) {
                        selectedGenre = state.selectedGenre;
                      }

                      final isSelected = selectedGenre == genre;
                      return GenreButton(
                        genre: genre,
                        isSelected: isSelected,
                        onTap: () {
                          if (!isSelected) {
                            context.read<BrowseCubit>().changeGenre(genre);
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<BrowseCubit, BrowseState>(
                builder: (context, state) {
                  if (state is BrowseLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is BrowseSuccess) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: state.movies.length,
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieGridItem(
                          movie: movie,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/movie-details',
                              arguments: movie,
                            );
                          },
                        );
                      },
                    );
                  } else if (state is BrowseError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.red,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.white),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<BrowseCubit>().changeGenre(
                                  state.selectedGenre,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: AppColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is BrowseEmpty) {
                    return const Center(
                      child: Text(
                        'No movies found for this genre',
                        style: TextStyle(color: AppColors.white),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
