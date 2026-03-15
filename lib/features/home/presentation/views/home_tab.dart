import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection_container.dart';
import 'package:movies/features/movies/presentation/manager/movies_cubit.dart';
import 'package:movies/features/movies/presentation/manager/movies_state.dart';
import 'package:movies/features/movies/domain/entities/movie_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/features/browse/presentation/cubit/browse_cubit.dart';
import 'package:movies/features/browse/presentation/views/browse_tab.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MoviesCubit>()..fetchMovies(),
      child: BlocBuilder<MoviesCubit, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is MoviesFailure) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: AppColors.white),
              ),
            );
          } else if (state is MoviesSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'available_now'.tr(),
                      style: GoogleFonts.pinyonScript(
                        fontSize: 32,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.65,
                    ),
                    items: state.topRatedMovies.map((movie) {
                      return MovieCard(movie: movie);
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'watch_now'.tr(),
                      style: GoogleFonts.pinyonScript(
                        fontSize: 36,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...state.moviesByCategory.entries.map((entry) {
                    return CategorySection(
                      category: entry.key,
                      movies: entry.value,
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;
  final List<MovieEntity> movies;

  const CategorySection({
    super.key,
    required this.category,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<BrowseCubit>().changeGenre(category);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(category),
                          backgroundColor: AppColors.backgroundDark,
                          elevation: 0,
                          iconTheme: const IconThemeData(color: Colors.white),
                        ),
                        backgroundColor: AppColors.backgroundDark,
                        body: const BrowseTab(),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'see_more'.tr(),
                      style: const TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Container(
                width: 130,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/movie-details',
                          arguments: movie,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            children: [
                              Image.network(
                                movie.mediumCoverImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: RatingTag(rating: movie.rating),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieEntity movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/movie-details', arguments: movie),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(movie.mediumCoverImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: RatingTag(rating: movie.rating),
          ),
        ),
      ),
    );
  }
}

class RatingTag extends StatelessWidget {
  final double rating;
  const RatingTag({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toString(),
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}
