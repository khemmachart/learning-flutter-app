import 'package:flutter/material.dart';
import 'package:learning_flutter_app/core/models/movie.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieListItem({Key? key, required this.movie, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}
