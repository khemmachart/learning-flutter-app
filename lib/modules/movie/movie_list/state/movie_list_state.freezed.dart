// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MovieListState {
  List<Movie> get popularMovies => throw _privateConstructorUsedError;
  List<Movie> get nowPlayingMovies => throw _privateConstructorUsedError;
  List<Movie> get topRatedMovies => throw _privateConstructorUsedError;
  int get popularCurrentPage => throw _privateConstructorUsedError;
  int get nowPlayingCurrentPage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  MovieDisplayMode get currentMode => throw _privateConstructorUsedError;

  /// Create a copy of MovieListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MovieListStateCopyWith<MovieListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieListStateCopyWith<$Res> {
  factory $MovieListStateCopyWith(
          MovieListState value, $Res Function(MovieListState) then) =
      _$MovieListStateCopyWithImpl<$Res, MovieListState>;
  @useResult
  $Res call(
      {List<Movie> popularMovies,
      List<Movie> nowPlayingMovies,
      List<Movie> topRatedMovies,
      int popularCurrentPage,
      int nowPlayingCurrentPage,
      bool isLoading,
      MovieDisplayMode currentMode});
}

/// @nodoc
class _$MovieListStateCopyWithImpl<$Res, $Val extends MovieListState>
    implements $MovieListStateCopyWith<$Res> {
  _$MovieListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MovieListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularMovies = null,
    Object? nowPlayingMovies = null,
    Object? topRatedMovies = null,
    Object? popularCurrentPage = null,
    Object? nowPlayingCurrentPage = null,
    Object? isLoading = null,
    Object? currentMode = null,
  }) {
    return _then(_value.copyWith(
      popularMovies: null == popularMovies
          ? _value.popularMovies
          : popularMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      nowPlayingMovies: null == nowPlayingMovies
          ? _value.nowPlayingMovies
          : nowPlayingMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      topRatedMovies: null == topRatedMovies
          ? _value.topRatedMovies
          : topRatedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      popularCurrentPage: null == popularCurrentPage
          ? _value.popularCurrentPage
          : popularCurrentPage // ignore: cast_nullable_to_non_nullable
              as int,
      nowPlayingCurrentPage: null == nowPlayingCurrentPage
          ? _value.nowPlayingCurrentPage
          : nowPlayingCurrentPage // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentMode: null == currentMode
          ? _value.currentMode
          : currentMode // ignore: cast_nullable_to_non_nullable
              as MovieDisplayMode,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MovieStateImplCopyWith<$Res>
    implements $MovieListStateCopyWith<$Res> {
  factory _$$MovieStateImplCopyWith(
          _$MovieStateImpl value, $Res Function(_$MovieStateImpl) then) =
      __$$MovieStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Movie> popularMovies,
      List<Movie> nowPlayingMovies,
      List<Movie> topRatedMovies,
      int popularCurrentPage,
      int nowPlayingCurrentPage,
      bool isLoading,
      MovieDisplayMode currentMode});
}

/// @nodoc
class __$$MovieStateImplCopyWithImpl<$Res>
    extends _$MovieListStateCopyWithImpl<$Res, _$MovieStateImpl>
    implements _$$MovieStateImplCopyWith<$Res> {
  __$$MovieStateImplCopyWithImpl(
      _$MovieStateImpl _value, $Res Function(_$MovieStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MovieListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularMovies = null,
    Object? nowPlayingMovies = null,
    Object? topRatedMovies = null,
    Object? popularCurrentPage = null,
    Object? nowPlayingCurrentPage = null,
    Object? isLoading = null,
    Object? currentMode = null,
  }) {
    return _then(_$MovieStateImpl(
      popularMovies: null == popularMovies
          ? _value._popularMovies
          : popularMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      nowPlayingMovies: null == nowPlayingMovies
          ? _value._nowPlayingMovies
          : nowPlayingMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      topRatedMovies: null == topRatedMovies
          ? _value._topRatedMovies
          : topRatedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      popularCurrentPage: null == popularCurrentPage
          ? _value.popularCurrentPage
          : popularCurrentPage // ignore: cast_nullable_to_non_nullable
              as int,
      nowPlayingCurrentPage: null == nowPlayingCurrentPage
          ? _value.nowPlayingCurrentPage
          : nowPlayingCurrentPage // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      currentMode: null == currentMode
          ? _value.currentMode
          : currentMode // ignore: cast_nullable_to_non_nullable
              as MovieDisplayMode,
    ));
  }
}

/// @nodoc

class _$MovieStateImpl extends _MovieState {
  const _$MovieStateImpl(
      {final List<Movie> popularMovies = const [],
      final List<Movie> nowPlayingMovies = const [],
      final List<Movie> topRatedMovies = const [],
      this.popularCurrentPage = 1,
      this.nowPlayingCurrentPage = 1,
      this.isLoading = false,
      this.currentMode = MovieDisplayMode.popular})
      : _popularMovies = popularMovies,
        _nowPlayingMovies = nowPlayingMovies,
        _topRatedMovies = topRatedMovies,
        super._();

  final List<Movie> _popularMovies;
  @override
  @JsonKey()
  List<Movie> get popularMovies {
    if (_popularMovies is EqualUnmodifiableListView) return _popularMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularMovies);
  }

  final List<Movie> _nowPlayingMovies;
  @override
  @JsonKey()
  List<Movie> get nowPlayingMovies {
    if (_nowPlayingMovies is EqualUnmodifiableListView)
      return _nowPlayingMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nowPlayingMovies);
  }

  final List<Movie> _topRatedMovies;
  @override
  @JsonKey()
  List<Movie> get topRatedMovies {
    if (_topRatedMovies is EqualUnmodifiableListView) return _topRatedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRatedMovies);
  }

  @override
  @JsonKey()
  final int popularCurrentPage;
  @override
  @JsonKey()
  final int nowPlayingCurrentPage;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final MovieDisplayMode currentMode;

  @override
  String toString() {
    return 'MovieListState(popularMovies: $popularMovies, nowPlayingMovies: $nowPlayingMovies, topRatedMovies: $topRatedMovies, popularCurrentPage: $popularCurrentPage, nowPlayingCurrentPage: $nowPlayingCurrentPage, isLoading: $isLoading, currentMode: $currentMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MovieStateImpl &&
            const DeepCollectionEquality()
                .equals(other._popularMovies, _popularMovies) &&
            const DeepCollectionEquality()
                .equals(other._nowPlayingMovies, _nowPlayingMovies) &&
            const DeepCollectionEquality()
                .equals(other._topRatedMovies, _topRatedMovies) &&
            (identical(other.popularCurrentPage, popularCurrentPage) ||
                other.popularCurrentPage == popularCurrentPage) &&
            (identical(other.nowPlayingCurrentPage, nowPlayingCurrentPage) ||
                other.nowPlayingCurrentPage == nowPlayingCurrentPage) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.currentMode, currentMode) ||
                other.currentMode == currentMode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_popularMovies),
      const DeepCollectionEquality().hash(_nowPlayingMovies),
      const DeepCollectionEquality().hash(_topRatedMovies),
      popularCurrentPage,
      nowPlayingCurrentPage,
      isLoading,
      currentMode);

  /// Create a copy of MovieListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MovieStateImplCopyWith<_$MovieStateImpl> get copyWith =>
      __$$MovieStateImplCopyWithImpl<_$MovieStateImpl>(this, _$identity);
}

abstract class _MovieState extends MovieListState {
  const factory _MovieState(
      {final List<Movie> popularMovies,
      final List<Movie> nowPlayingMovies,
      final List<Movie> topRatedMovies,
      final int popularCurrentPage,
      final int nowPlayingCurrentPage,
      final bool isLoading,
      final MovieDisplayMode currentMode}) = _$MovieStateImpl;
  const _MovieState._() : super._();

  @override
  List<Movie> get popularMovies;
  @override
  List<Movie> get nowPlayingMovies;
  @override
  List<Movie> get topRatedMovies;
  @override
  int get popularCurrentPage;
  @override
  int get nowPlayingCurrentPage;
  @override
  bool get isLoading;
  @override
  MovieDisplayMode get currentMode;

  /// Create a copy of MovieListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MovieStateImplCopyWith<_$MovieStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
