class Review {
  final String author;
  final String content;
  final String createdAt;
  final double? rating;

  Review({
    required this.author,
    required this.content,
    required this.createdAt,
    this.rating,
  });
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'],
      content: json['content'],
      createdAt: json['created_at'],
      rating: json['author_details']['rating']?.toDouble(),
    );
  }
}
