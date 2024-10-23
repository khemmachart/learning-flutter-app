import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/providers/moview_list_view_model_provider.dart';
import 'package:learning_flutter_app/modules/movie_detail/movie_detail_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

final movieDisplayModeProvider = StateProvider<MovieDisplayMode>((ref) => MovieDisplayMode.nowShowing);

enum MovieDisplayMode { popular, nowShowing }

class MovieListPage extends ConsumerStatefulWidget {
  const MovieListPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends ConsumerState<MovieListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      ref.read(movieListViewModelProvider.notifier).fetchTopRatedMovies()
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayMode = ref.watch(movieDisplayModeProvider);
    final moviesAsyncValue = ref.watch(movieListViewModelProvider);
    final topRatedMovies = ref.watch(movieListViewModelProvider.notifier).topRatedMovies;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          _buildDisplayModeButton(displayMode, ref),
        ],
      ),
      body: moviesAsyncValue.when(
        data: (movies) => _buildMovieList(movies, topRatedMovies),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies, List<Movie> topRatedMovies) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ListView(
        children: [
          _buildTopRatedSection(topRatedMovies),
          const DisplayModeTitle(),
          ...movies.map((movie) => _buildMovieListItem(context, movie)),
          _buildLoadMoreIndicator(),
        ],
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      ref.read(movieListViewModelProvider.notifier).loadMore();
    }
    return true;
  }

  Widget _buildTopRatedSection(List<Movie> topRatedMovies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Top Rated Movies',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: topRatedMovies.map((movie) => _buildCarouselItem(movie)).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCarouselItem(Movie movie) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => _navigateToMovieDetail(context, movie),
          child: Hero(
            tag: 'top-rated-movie-${movie.id}',
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(movie.posterPath ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildCarouselItemOverlay(movie),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarouselItemOverlay(Movie movie) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDisplayModeButton(MovieDisplayMode displayMode, WidgetRef ref) {
    return PopupMenuButton<MovieDisplayMode>(
      initialValue: displayMode,
      onSelected: (MovieDisplayMode mode) {
        ref.read(movieDisplayModeProvider.notifier).state = mode;
        ref.read(movieListViewModelProvider.notifier).changeDisplayMode(mode);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MovieDisplayMode>>[
        const PopupMenuItem<MovieDisplayMode>(
          value: MovieDisplayMode.popular,
          child: Text('Popular'),
        ),
        const PopupMenuItem<MovieDisplayMode>(
          value: MovieDisplayMode.nowShowing,
          child: Text('Now Showing'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              displayMode == MovieDisplayMode.popular ? 'Popular' : 'Now Showing',
              style: TextStyle(color: Colors.blue[700]),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToMovieDetail(context, movie),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoviePoster(movie),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMovieInfo(movie),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(Movie movie) {
    return Hero(
      tag: 'movie-poster-${movie.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: movie.posterPath != null
          ? Image.network(
              movie.posterPath!,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            )
          : Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.movie, color: Colors.white, size: 40),
            ),
      ),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return Hero(
      tag: 'movie-info-${movie.id}',
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900], fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              movie.genres.join(", "),
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              movie.overview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[700], size: 20),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }
}

class DisplayModeTitle extends ConsumerWidget {
  const DisplayModeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(movieDisplayModeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Movies',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildDisplayModeToggle(context, ref, displayMode),
        ],
      ),
    );
  }

  Widget _buildDisplayModeToggle(BuildContext context, WidgetRef ref, MovieDisplayMode displayMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[100]!.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(
              child: _buildSegmentButton(
                context,
                ref,
                'Popular',
                MovieDisplayMode.popular,
                displayMode == MovieDisplayMode.popular,
              ),
            ),
            Expanded(
              child: _buildSegmentButton(
                context,
                ref,
                'Now Playing',
                MovieDisplayMode.nowShowing,
                displayMode == MovieDisplayMode.nowShowing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(BuildContext context, WidgetRef ref, String title, MovieDisplayMode mode, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(movieDisplayModeProvider.notifier).state = mode;
          ref.read(movieListViewModelProvider.notifier).changeDisplayMode(mode);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue[300]!.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
