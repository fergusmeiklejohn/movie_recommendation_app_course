import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/movie.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final moviedbRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(moviedbRepository);
});

abstract class MovieService {
  Future<List<Genre>> getGenres();
  Future<List<Movie>> getRecommendedMovie(int rating, int yearsBack, List<Genre> genres, [DateTime? yearsBackFromDate]);
}

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieDbRepository);
  final MovieRepository _movieDbRepository;

  @override
  Future<List<Genre>> getGenres() async {
    final genreEntities = await _movieDbRepository.getMovieGenres();
    final genres = genreEntities.map((e) => Genre.fromEntity(e)).toList(growable: false);
    return genres;
  }

  @override
  Future<List<Movie>> getRecommendedMovie(int rating, int yearsBack, List<Genre> genres, [DateTime? yearsBackFromDate]) async {
    final date = yearsBackFromDate ?? DateTime.now();
    final year = date.year - yearsBack;
    final genreIds = genres.map((e) => e.id).toList(growable: false).join(',');
    final movieEntities = await _movieDbRepository.getRecommendedMovie(rating.toDouble(), '$year-01-01', genreIds);
    final movies = movieEntities.map((e) => Movie.fromEntity(e, genres)).toList(growable: false);

    return movies;
  }
}
