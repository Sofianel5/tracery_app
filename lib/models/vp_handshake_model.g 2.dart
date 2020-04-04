// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vp_handshake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenuePeerHandshake _$VenuePeerHandshakeFromJson(Map<String, dynamic> json) {
  return VenuePeerHandshake(
    venue: json['venue'] == null
        ? null
        : Venue.fromJson(json['venue'] as Map<String, dynamic>),
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
  )..user = json['person'] == null
      ? null
      : AnonUser.fromJson(json['person'] as Map<String, dynamic>);
}

Map<String, dynamic> _$VenuePeerHandshakeToJson(VenuePeerHandshake instance) =>
    <String, dynamic>{
      'venue': instance.venue?.toJson(),
      'person': instance.user?.toJson(),
      'time': instance.time?.toIso8601String(),
    };
