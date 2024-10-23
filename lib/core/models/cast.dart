class Cast {
  final String name;
  final String? character;
  final String? profilePath;

  Cast({required this.name, this.character, this.profilePath});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
      character: json['character'],
      profilePath: json['profile_path'] != null ? 'https://image.tmdb.org/t/p/w185${json['profile_path']}' : null,
    );
  }
}