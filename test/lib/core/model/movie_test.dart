import 'package:flutter_test/flutter_test.dart';
import 'package:learning_flutter_app/core/models/movie.dart';
import 'package:learning_flutter_app/core/models/cast.dart';

void main() {
  group('Movie.fromJson', () {
    test('correctly maps genre IDs to names', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 123,
        'title': 'Genre Test Movie',
        'vote_average': 7.5,
        'overview': 'A movie to test genre mapping',
        'genre_ids': [28, 12, 16, 99],
        'release_date': '2023-05-01',
      };

      final Map<int, String> genreMap = {
        28: 'Action',
        12: 'Adventure',
        16: 'Animation',
        99: 'Documentary',
        35: 'Comedy',
      };

      // Act
      final movie = Movie.fromJson(json, genreMap);

      // Assert
      expect(movie.genres, ['Action', 'Adventure', 'Animation', 'Documentary']);
    });

    test('handles unknown genre IDs', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 124,
        'title': 'Unknown Genre Movie',
        'vote_average': 6.5,
        'overview': 'A movie with some unknown genres',
        'genre_ids': [28, 999, 16, 1000],
        'release_date': '2023-06-01',
      };

      final Map<int, String> genreMap = {
        28: 'Action',
        16: 'Animation',
      };

      // Act
      final movie = Movie.fromJson(json, genreMap);

      // Assert
      expect(movie.genres, ['Action', 'Unknown', 'Animation', 'Unknown']);
    });

    test('correctly maps and limits cast list', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': 125,
        'title': 'Cast Test Movie',
        'vote_average': 8.0,
        'overview': 'A movie to test cast mapping',
        'genre_ids': [],
        'release_date': '2023-07-01',
        'credits': {
          'cast': List.generate(15, (index) => {
            'id': index + 1,
            'name': 'Actor ${index + 1}',
            'character': 'Character ${index + 1}'
          })
        }
      };

      // Act
      final movie = Movie.fromJson(json, {});

      // Assert
      expect(movie.cast.length, 10);
      expect(movie.cast.first, isA<Cast>());
      expect(movie.cast.first.name, 'Actor 1');
      expect(movie.cast.last.name, 'Actor 10');
    });

    test('handles missing or empty cast list', () {
      // Arrange
      final Map<String, dynamic> jsonNoCast = {
        'id': 126,
        'title': 'No Cast Movie',
        'vote_average': 5.5,
        'overview': 'A movie without a cast list',
        'genre_ids': [],
        'release_date': '2023-08-01',
      };

      final Map<String, dynamic> jsonEmptyCast = {
        'id': 127,
        'title': 'Empty Cast Movie',
        'vote_average': 6.0,
        'overview': 'A movie with an empty cast list',
        'genre_ids': [],
        'release_date': '2023-09-01',
        'credits': {'cast': []}
      };

      // Act
      final movieNoCast = Movie.fromJson(jsonNoCast, {});
      final movieEmptyCast = Movie.fromJson(jsonEmptyCast, {});

      // Assert
      expect(movieNoCast.cast, isEmpty);
      expect(movieEmptyCast.cast, isEmpty);
    });
  });
}