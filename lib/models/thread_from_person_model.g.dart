// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_from_person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadFromPerson _$ThreadFromPersonFromJson(Map<String, dynamic> json) {
  return ThreadFromPerson(
    threadId: json['thread_id'] as String,
    to: json['_to'] == null
        ? null
        : Venue.fromJson(json['_to'] as Map<String, dynamic>),
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
    toConfirmed: json['to_confirmed'] as bool,
  )
    ..from = json['_from'] == null
        ? null
        : AnonUser.fromJson(json['_from'] as Map<String, dynamic>)
    ..fromConfirmed = json['from_confirmed'] as bool;
}

Map<String, dynamic> _$ThreadFromPersonToJson(ThreadFromPerson instance) =>
    <String, dynamic>{
      'thread_id': instance.threadId,
      '_to': instance.to?.toJson(),
      '_from': instance.from?.toJson(),
      'time': instance.time?.toIso8601String(),
      'from_confirmed': instance.fromConfirmed,
      'to_confirmed': instance.toConfirmed,
    };
