


class MovieModel {
  String? id;
  String? rank;
  String? title;
  String? overview;
  String? release_date;
  String? posterPath;
  String? original_language;
  var voteAverage;
  String? imDbRatingCount;

  MovieModel(
      {this.id,
      this.rank,
      this.title,
      this.overview,
      this.release_date,
      this.posterPath,
      this.original_language,
      this.voteAverage,
      this.imDbRatingCount});


}
