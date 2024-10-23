import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/cast.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/review.dart';
import 'package:learning_flutter_app/core/providers/movie_provider.dart';
import 'package:learning_flutter_app/core/utils/extensions/string_extensions.dart';
import 'package:learning_flutter_app/modules/checkout/page/checkout_page.dart';

class MovieDetailPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailState = ref.watch(movieDetailViewModelProvider(movie.id));

    return Scaffold(
      body: movieDetailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieDetailState.movie == null
              ? const Center(child: Text('Error loading movie details'))
              : Stack(
                  children: [
                    _buildMovieDetails(context, movieDetailState.movie!, movieDetailState.reviews),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        child: _buildBookButton(context, movieDetailState.movie!),
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
              _buildMovieInfo(movie),
              const SizedBox(height: 32),
              _buildOverview(movie),
              const SizedBox(height: 32),
              _buildCast(movie),
              const SizedBox(height: 32),
              _buildReviews(context, reviews),
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
        background: Hero(
          tag: 'movie-backdrop-${movie.id}',
          child: Image.network(
            movie.backdropPath ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'movie-poster-${movie.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterPath ?? '',
              height: 180,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildInfoText('Release Date', movie.releaseDate),
              _buildInfoText('Runtime', '${movie.runtime} minutes'),
              _buildInfoText('Genres', movie.genres.join(", ")),
              const SizedBox(height: 4),
              _buildRatingWidget(movie.voteAverage),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text('$label: $value', style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildRatingWidget(double rating) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 24),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOverview(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          movie.overview,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildCast(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cast',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie.cast.length,
            itemBuilder: (context, index) => _buildCastMember(movie.cast[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCastMember(Cast cast) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: cast.profilePath != null ? NetworkImage(cast.profilePath!) : null,
            child: cast.profilePath == null ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              cast.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (cast.character != null)
            SizedBox(
              width: 80,
              child: Text(
                cast.character!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviews(BuildContext context, List<Review> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length + 1,
          itemBuilder: (context, index) {
            if (index < reviews.length) {
              return _buildReviewCard(reviews[index]);
            } else {
              return _buildLoadMoreReviewsButton(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.author,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                if (review.rating != null) _buildRatingWidget(review.rating!),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              'Posted on ${(review.createdAt).formatDate()}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreReviewsButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final movieDetailState = ref.watch(movieDetailViewModelProvider(movie.id));
        if (!movieDetailState.hasMoreReviews) return const SizedBox.shrink();

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: movieDetailState.isLoadingReviews
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      ref.read(movieDetailViewModelProvider(movie.id).notifier).loadReviews();
                    },
                    child: const Text('Load More Reviews', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
          ),
        );
      },
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
