import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection_container.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:movies/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:movies/features/wishlist/presentation/manager/wishlist_state.dart';
import 'package:movies/features/history/presentation/manager/history_cubit.dart';
import '../manager/movie_details_cubit.dart';
import '../manager/movie_details_state.dart';
import 'package:movies/core/theme/app_colors.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final int? movieId;

    if (args is MovieEntity) {
      movieId = args.id;
    } else if (args is int) {
      movieId = args;
    } else {
      movieId = null;
    }

    if (movieId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No Movie Data',
            style: TextStyle(color: AppColors.white),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => getIt<MovieDetailsCubit>()..loadMovie(movieId!),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: BlocConsumer<MovieDetailsCubit, MovieDetailsState>(
          listener: (context, state) {
            if (state is MovieDetailsSuccess) {
              context.read<HistoryCubit>().addToHistory(state.movie);
              if (context.read<WishlistCubit>().state is! WishlistLoaded) {
                context.read<WishlistCubit>().getWishlist();
              }
            }
          },
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is MovieDetailsSuccess) {
              final movie = state.movie;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          movie.backgroundImage ?? movie.mediumCoverImage,
                          width: double.infinity,
                          height: 450,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(height: 450, color: Colors.grey[800]),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.backgroundDark,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.4, 1.0],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  BlocConsumer<WishlistCubit, WishlistState>(
                                    listener: (context, state) {
                                      if (state is WishlistError) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(state.message),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      bool isInWishlist = false;
                                      if (state is WishlistLoaded) {
                                        isInWishlist = state.movies.any(
                                          (m) => m.id == movie.id,
                                        );
                                      }

                                      return IconButton(
                                        onPressed: () {
                                          context
                                              .read<WishlistCubit>()
                                              .toggleWishlist(movie);
                                        },
                                        icon: Icon(
                                          isInWishlist
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                          color: isInWishlist
                                              ? AppColors.primary
                                              : AppColors.white,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 4,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            movie.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.year.toString(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Watch',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatPill(
                                AppColors.inputBackgroundDark,
                                AppColors.primary,
                                Icons.favorite,
                                movie.likeCount?.toString() ?? '0',
                              ),
                              _buildStatPill(
                                AppColors.inputBackgroundDark,
                                AppColors.primary,
                                Icons.access_time_filled,
                                movie.runtime?.toString() ?? 'N/A',
                              ),
                              _buildStatPill(
                                AppColors.inputBackgroundDark,
                                AppColors.primary,
                                Icons.star,
                                movie.rating.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Genres'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: movie.genres
                            .map(
                              (genre) => _buildGenreChip(
                                AppColors.inputBackgroundDark,
                                genre,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Summary'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        movie.summary,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (movie.cast.isNotEmpty) ...[
                      _buildSectionTitle('Cast'),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.cast.length,
                          itemBuilder: (context, index) {
                            final actor = movie.cast[index];
                            return Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: actor.urlSmallImage != null
                                        ? NetworkImage(actor.urlSmallImage!)
                                        : null,
                                    backgroundColor:
                                        AppColors.inputBackgroundDark,
                                    child: actor.urlSmallImage == null
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.white54,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    actor.name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (movie.screenshots.isNotEmpty) ...[
                      _buildSectionTitle('Screenshots'),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.screenshots.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 250,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(movie.screenshots[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              );
            } else if (state is MovieDetailsFailure) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: AppColors.white),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 12.0, right: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatPill(
    Color bgColor,
    Color iconColor,
    IconData icon,
    String text,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChip(Color bgColor, String genre) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        genre,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
