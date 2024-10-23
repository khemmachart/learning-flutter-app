import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast.freezed.dart';
part 'cast.g.dart';

@freezed
class Cast with _$Cast {
  const factory Cast({
    required String name,
    String? character,
    String? profilePath,
  }) = _Cast;

  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
}

extension CastExtension on Cast {
  String? get fullProfilePath => profilePath != null 
    ? 'https://image.tmdb.org/t/p/w185$profilePath' 
    : null;
}