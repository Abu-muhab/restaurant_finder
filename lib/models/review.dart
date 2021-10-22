class Review {
  String authorName;
  String review;
  double rating;
  String timeDescription;

  Review(
      {this.rating = 0,
      this.authorName = "",
      this.review = "",
      this.timeDescription = ""});

  factory Review.fromJson(Map json) {
    return Review(
        authorName: json['author_name'],
        review: json['text'],
        rating: double.parse(json['rating'].toString()),
        timeDescription: json['relative_time_description']);
  }
}
