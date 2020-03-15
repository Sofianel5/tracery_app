// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_from_venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadFromVenueModel _$ThreadFromVenueModelFromJson(Map<String, dynamic> json) {
  return ThreadFromVenueModel(
    threadId: json['thread_id'] as String,
    from: json['_from'] == null
        ? null
        : Venue.fromJson(json['_from'] as Map<String, dynamic>),
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    toConfirmed: json['to_confirmed'] as bool,
  )..fromConfirmed = json['from_confirmed'] as bool;
}

Map<String, dynamic> _$ThreadFromVenueModelToJson(
        ThreadFromVenueModel instance) =>
    <String, dynamic>{
      'thread_id': instance.threadId,
      '_from': instance.from?.toJson(),
      'time': instance.time?.toIso8601String(),
      'from_confirmed': instance.fromConfirmed,
      'to_confirmed': instance.toConfirmed,
    };
