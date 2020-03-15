// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vp_handshake_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenuePeerHandshake _$VenuePeerHandshakeFromJson(Map<String, dynamic> json) {
  return VenuePeerHandshake(
    from: json['venue'] == null
        ? null
        : Venue.fromJson(json['venue'] as Map<String, dynamic>),
    time: json['time'] == null ? null : DateTime.parse(json['time'] as String),
  );
}

Map<String, dynamic> _$VenuePeerHandshakeToJson(VenuePeerHandshake instance) =>
    <String, dynamic>{
      'venue': instance.from?.toJson(),
      'time': instance.time?.toIso8601String(),
    };
