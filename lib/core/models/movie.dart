import 'package:learning_flutter_app/core/models/cast.dart';

class Movie {
  final int id;
  final String title;
  final double voteAverage;
  final String overview;
  final List<String> genres;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final int? runtime;
  final List<Cast> cast;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.genres,
    required this.releaseDate,
    required this.cast,
    this.posterPath,
    this.backdropPath,
    this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json, Map<int, String> genreMap) {
    List<String> genreNames = (json['genre_ids'] as List<dynamic>?)
        ?.map((id) => genreMap[id] ?? 'Unknown')
        .toList() ?? [];

    List<Cast> castList = [];
    if (json['credits'] != null && json['credits']['cast'] != null) {
      castList = (json['credits']['cast'] as List)
          .map((castJson) => Cast.fromJson(castJson))
          .take(10) // Limit to top 10 cast members
          .toList();
    }

    return Movie(
      id: json['id'],
      title: json['title'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      genres: genreNames,
      posterPath: json['poster_path'] != null ? 'https://image.tmdb.org/t/p/w200${json['poster_path']}' : null,
      backdropPath: json['backdrop_path'] != null ? 'https://image.tmdb.org/t/p/original${json['backdrop_path']}' : null,
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      cast: castList,
    );
  }
}
