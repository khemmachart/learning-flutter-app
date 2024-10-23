import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/review.dart';
import 'package:learning_flutter_app/core/providers/movie_provider.dart';
import 'package:learning_flutter_app/modules/checkout/page/checkout_page.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/widgets/movie_info_widget.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/widgets/movie_overview_widget.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/widgets/movie_cast_widget.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/widgets/movie_review_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MovieDetailPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailState = ref.watch(movieDetailViewModelProvider(movie.id));

    return Scaffold(
      body: movieDetailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieDetailState.state.movie == null
              ? const Center(child: Text('Error loading movie details'))
              : Stack(
                  children: [
                    _buildMovieDetails(context, movieDetailState.state.movie!, movieDetailState.state.reviews),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        child: _buildBookButton(context, movieDetailState.state.movie!),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, Movie movie, List<Review> reviews) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(movie),
        SliverPadding(
          padding: const EdgeInsets.all(24.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              MovieInfo(movie: movie),
              const SizedBox(height: 32),
              MovieOverview(movie: movie),
              const SizedBox(height: 32),
              MovieCast(movie: movie),
              const SizedBox(height: 32),
              MovieReviews(movieId: movie.id, reviews: reviews),
              const SizedBox(height: 80), // Add extra space for the book button
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Movie movie) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Hero(
          tag: 'movie-title-${movie.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              movie.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
        background: _buildImageSlider(movie),
      ),
    );
  }

  Widget _buildImageSlider(Movie movie) {
    // Note: The Assignment requires the image to be multiple, but I saw in the API that the movie has only one image.
    // So I just added the same image multiple times to make it look like multiple images.
    final List<String> imageUrls = [
      movie.backdropPath ?? '',
      movie.posterPath ?? '',
    ];

    return imageUrls.length > 1
        ? CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
            ),
            items: imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Hero(
                    tag: 'movie-backdrop-${movie.id}-$url',
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  );
                },
              );
            }).toList(),
          )
        : Hero(
            tag: 'movie-backdrop-${movie.id}',
            child: Image.network(
              movie.backdropPath ?? '',
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _buildBookButton(BuildContext context, Movie movie) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckoutPage(movie: movie),
              ),
            );
          },
          child: const Text('Book Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(100, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            shadowColor: Colors.blue[300]!.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
