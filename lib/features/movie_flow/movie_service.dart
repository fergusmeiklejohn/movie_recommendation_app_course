import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/core/failure.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/movie.dart';
import 'package:multiple_result/multiple_result.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final moviedbRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(moviedbRepository);
});

abstract class MovieService {
  Future<Result<Failure, List<Genre>>> getGenres();
  Future<Result<Failure, List<Movie>>> getRecommendedMovie(int rating, int yearsBack, List<Genre> genres, [DateTime? yearsBackFromDate]);
}

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieDbRepository);
  final MovieRepository _movieDbRepository;

  @override
  Future<Result<Failure, List<Genre>>> getGenres() async {
    try {
      final genreEntities = await _movieDbRepository.getMovieGenres();
      final genres = genreEntities.map((e) => Genre.fromEntity(e)).toList(growable: false);
      return Success(genres);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }

  @override
  Future<Result<Failure, List<Movie>>> getRecommendedMovie(int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFromDate]) async {
    final date = yearsBackFromDate ?? DateTime.now();
    final year = date.year - yearsBack;
    final genreIds = genres.map((e) => e.id).toList(growable: false).join(',');
    try {
      final movieEntities = await _movieDbRepository.getRecommendedMovie(rating.toDouble(), '$year-01-01', genreIds);
      final movies = movieEntities.map((e) => Movie.fromEntity(e, genres)).toList(growable: false);

      if (movies.isEmpty) {
        return Error(Failure(message: 'No movies found'));
      }

      return Success(movies);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }
}
