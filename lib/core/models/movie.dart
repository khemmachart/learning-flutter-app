import 'package:freezed_annotation/freezed_annotation.dart';
import 'cast.dart';

part 'movie.freezed.dart';

@freezed
class Movie with _$Movie {
  const Movie._();

  const factory Movie({
    required int id,
    required String title,
    required double voteAverage,
    required String overview,
    required List<String> genres,
    required String releaseDate,
    required List<Cast> cast,
    String? posterPath,
    String? backdropPath,
    int? runtime,
  }) = _Movie;

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
