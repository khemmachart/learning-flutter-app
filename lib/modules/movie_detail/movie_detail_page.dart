import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/cast.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/review.dart';
import 'package:learning_flutter_app/core/providers/moview_list_view_model_provider.dart';
import 'package:learning_flutter_app/core/utils/extensions/string_extensions.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  final Movie movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  late Future<Movie> _movieDetailsFuture;
  List<Review> _reviews = [];
  int _currentReviewPage = 1;
  bool _hasMoreReviews = true;
  bool _isLoadingReviews = false;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = _fetchMovieDetails();
    _loadReviews();
  }

  Future<Movie> _fetchMovieDetails() {
    return ref.read(movieListViewModelProvider.notifier).fetchMovieDetails(widget.movie.id);
  }

  Future<void> _loadReviews() async {
    if (!_hasMoreReviews || _isLoadingReviews) return;
    setState(() => _isLoadingReviews = true);
    try {
      final newReviews = await ref.read(movieListViewModelProvider.notifier).fetchMovieReviews(widget.movie.id, page: _currentReviewPage);
      setState(() {
        _reviews.addAll(newReviews);
        _currentReviewPage++;
        _hasMoreReviews = newReviews.isNotEmpty;
        _isLoadingReviews = false;
      });
    } catch (e) {
      setState(() => _isLoadingReviews = false);
      // TODO: Handle error properly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final movie = snapshot.data!;
            return _buildMovieDetails(movie);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie) {
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
              _buildReviews(),
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

  Widget _buildReviews() {
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
          itemCount: _reviews.length + 1,
          itemBuilder: (context, index) {
            if (index < _reviews.length) {
              return _buildReviewCard(_reviews[index]);
            } else {
              return _buildLoadMoreReviewsButton();
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

  Widget _buildLoadMoreReviewsButton() {
    if (!_hasMoreReviews) return const SizedBox.shrink();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: _isLoadingReviews
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _loadReviews,
                child: const Text('Load More Reviews', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
      ),
    );
  }
}
