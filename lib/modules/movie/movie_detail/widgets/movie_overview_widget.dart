import 'package:flutter/material.dart';
import 'package:learning_flutter_app/core/models/movie.dart';

class MovieOverview extends StatelessWidget {
  final Movie movie;

  const MovieOverview({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}