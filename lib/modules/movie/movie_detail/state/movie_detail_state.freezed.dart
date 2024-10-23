// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MovieDetailState {
  Movie? get movie => throw _privateConstructorUsedError;
  List<Review> get reviews => throw _privateConstructorUsedError;
  int get currentReviewPage => throw _privateConstructorUsedError;
  bool get hasMoreReviews => throw _privateConstructorUsedError;
  bool get isLoadingReviews => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieDetailStateCopyWith<MovieDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieDetailStateCopyWith<$Res> {
  factory $MovieDetailStateCopyWith(
          MovieDetailState value, $Res Function(MovieDetailState) then) =
      _$MovieDetailStateCopyWithImpl<$Res, MovieDetailState>;
  @useResult
  $Res call(
      {Movie? movie,
      List<Review> reviews,
      int currentReviewPage,
      bool hasMoreReviews,
      bool isLoadingReviews,
      bool isLoading});

  $MovieCopyWith<$Res>? get movie;
}

/// @nodoc
class _$MovieDetailStateCopyWithImpl<$Res, $Val extends MovieDetailState>
    implements $MovieDetailStateCopyWith<$Res> {
  _$MovieDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movie = freezed,
    Object? reviews = null,
    Object? currentReviewPage = null,
    Object? hasMoreReviews = null,
    Object? isLoadingReviews = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      movie: freezed == movie
          ? _value.movie
          : movie // ignore: cast_nullable_to_non_nullable
              as Movie?,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      currentReviewPage: null == currentReviewPage
          ? _value.currentReviewPage
          : currentReviewPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreReviews: null == hasMoreReviews
          ? _value.hasMoreReviews
          : hasMoreReviews // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingReviews: null == isLoadingReviews
          ? _value.isLoadingReviews
          : isLoadingReviews // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MovieCopyWith<$Res>? get movie {
    if (_value.movie == null) {
      return null;
    }

    return $MovieCopyWith<$Res>(_value.movie!, (value) {
      return _then(_value.copyWith(movie: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MovieDetailStateImplCopyWith<$Res>
    implements $MovieDetailStateCopyWith<$Res> {
  factory _$$MovieDetailStateImplCopyWith(_$MovieDetailStateImpl value,
          $Res Function(_$MovieDetailStateImpl) then) =
      __$$MovieDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Movie? movie,
      List<Review> reviews,
      int currentReviewPage,
      bool hasMoreReviews,
      bool isLoadingReviews,
      bool isLoading});

  @override
  $MovieCopyWith<$Res>? get movie;
}

/// @nodoc
class __$$MovieDetailStateImplCopyWithImpl<$Res>
    extends _$MovieDetailStateCopyWithImpl<$Res, _$MovieDetailStateImpl>
    implements _$$MovieDetailStateImplCopyWith<$Res> {
  __$$MovieDetailStateImplCopyWithImpl(_$MovieDetailStateImpl _value,
      $Res Function(_$MovieDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movie = freezed,
    Object? reviews = null,
    Object? currentReviewPage = null,
    Object? hasMoreReviews = null,
    Object? isLoadingReviews = null,
    Object? isLoading = null,
  }) {
    return _then(_$MovieDetailStateImpl(
      movie: freezed == movie
          ? _value.movie
          : movie // ignore: cast_nullable_to_non_nullable
              as Movie?,
      reviews: null == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      currentReviewPage: null == currentReviewPage
          ? _value.currentReviewPage
          : currentReviewPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreReviews: null == hasMoreReviews
          ? _value.hasMoreReviews
          : hasMoreReviews // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingReviews: null == isLoadingReviews
          ? _value.isLoadingReviews
          : isLoadingReviews // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MovieDetailStateImpl implements _MovieDetailState {
  const _$MovieDetailStateImpl(
      {this.movie,
      final List<Review> reviews = const [],
      this.currentReviewPage = 1,
      this.hasMoreReviews = true,
      this.isLoadingReviews = false,
      this.isLoading = false})
      : _reviews = reviews;

  @override
  final Movie? movie;
  final List<Review> _reviews;
  @override
  @JsonKey()
  List<Review> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  @override
  @JsonKey()
  final int currentReviewPage;
  @override
  @JsonKey()
  final bool hasMoreReviews;
  @override
  @JsonKey()
  final bool isLoadingReviews;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'MovieDetailState(movie: $movie, reviews: $reviews, currentReviewPage: $currentReviewPage, hasMoreReviews: $hasMoreReviews, isLoadingReviews: $isLoadingReviews, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieDetailStateImpl &&
            (identical(other.movie, movie) || other.movie == movie) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.currentReviewPage, currentReviewPage) ||
                other.currentReviewPage == currentReviewPage) &&
            (identical(other.hasMoreReviews, hasMoreReviews) ||
                other.hasMoreReviews == hasMoreReviews) &&
            (identical(other.isLoadingReviews, isLoadingReviews) ||
                other.isLoadingReviews == isLoadingReviews) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      movie,
      const DeepCollectionEquality().hash(_reviews),
      currentReviewPage,
      hasMoreReviews,
      isLoadingReviews,
      isLoading);

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieDetailStateImplCopyWith<_$MovieDetailStateImpl> get copyWith =>
      __$$MovieDetailStateImplCopyWithImpl<_$MovieDetailStateImpl>(
          this, _$identity);
}

abstract class _MovieDetailState implements MovieDetailState {
  const factory _MovieDetailState(
      {final Movie? movie,
      final List<Review> reviews,
      final int currentReviewPage,
      final bool hasMoreReviews,
      final bool isLoadingReviews,
      final bool isLoading}) = _$MovieDetailStateImpl;

  @override
  Movie? get movie;
  @override
  List<Review> get reviews;
  @override
  int get currentReviewPage;
  @override
  bool get hasMoreReviews;
  @override
  bool get isLoadingReviews;
  @override
  bool get isLoading;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieDetailStateImplCopyWith<_$MovieDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
