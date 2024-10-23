import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/providers/movie_provider.dart';
import 'package:learning_flutter_app/modules/movie/movie_detail/page/movie_detail_page.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/state/movie_list_state.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/widgets/top_rated_section.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/widgets/display_mode_title.dart';
import 'package:learning_flutter_app/modules/movie/movie_list/widgets/movie_list_item.dart';

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
    final movieState = ref.watch(movieListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          _buildDisplayModeButton(movieState.state.currentMode),
        ],
      ),
      body: _buildMovieList(movieState.state),
    );
  }

  Widget _buildMovieList(MovieListState movieState) {
    final movies = movieState.currentMode == MovieDisplayMode.popular
        ? movieState.popularMovies
        : movieState.nowPlayingMovies;

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ListView(
        children: [
          TopRatedSection(topRatedMovies: movieState.topRatedMovies),
          const DisplayModeTitle(),
          ...movies.map((movie) => MovieListItem(movie: movie, onTap: () => _navigateToMovieDetail(context, movie))),
          if (movieState.isLoading) _buildLoadMoreIndicator(),
        ],
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification scrollInfo) {
    if (!scrollInfo.metrics.outOfRange) {
      if (scrollInfo.metrics.pixels > scrollInfo.metrics.maxScrollExtent - 500) {
        ref.read(movieListViewModelProvider.notifier).loadMore();
      }
    }
    return true;
  }

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildDisplayModeButton(MovieDisplayMode displayMode) {
    return PopupMenuButton<MovieDisplayMode>(
      initialValue: displayMode,
      onSelected: (MovieDisplayMode selectedMode) {
        // Trigger the mode switch here
        ref.read(movieListViewModelProvider.notifier).changeDisplayMode(selectedMode);
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

  void _navigateToMovieDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: movie),
      ),
    );
  }
}
