// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Venue _$VenueFromJson(Map<String, dynamic> json) {
  return Venue(
    title: json['title'] as String,
    coordinates: json['coordinates'] == null
        ? null
        : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    publicId: json['public_id'] as String,
    securityValue: (json['security_value'] as num)?.toDouble(),
  )..securityLevel = json['security_level'] as String;
}

Map<String, dynamic> _$VenueToJson(Venue instance) => <String, dynamic>{
      'title': instance.title,
      'coordinates': instance.coordinates?.toJson(),
      'security_level': instance.securityLevel,
      'public_id': instance.publicId,
      'security_value': instance.securityValue,
    };
