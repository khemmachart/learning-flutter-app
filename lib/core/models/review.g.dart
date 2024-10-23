// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      author: json['author'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'author': instance.author,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'rating': instance.rating,
    };
