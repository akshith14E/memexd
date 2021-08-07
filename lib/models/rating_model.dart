class Rating {
  final String rating;

  const Rating({required this.rating});
  factory Rating.fromJson(dynamic json, dynamic id) => Rating(rating: json[id]);

  Rating copyWith({
    String? rating,
  }) {
    return Rating(
      rating: rating ?? this.rating,
    );
  }
}
