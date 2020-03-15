// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    puid: json['public_id'] as String,
  )
    ..securityLevel = json['security_level'] as String
    ..securityValue = (json['security_value'] as num)?.toDouble()
    ..qrImgUrl = json['qr_img'] as String
    ..isVenueAdmin = json['is_venueadmin'] as bool
    ..isGovAgent = json['is_gov'] as bool
    ..dateOfBirth =
        json['dob'] == null ? null : DateTime.parse(json['dob'] as String)
    ..isLocked = json['is_locked'] as bool;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'public_id': instance.puid,
      'security_level': instance.securityLevel,
      'security_value': instance.securityValue,
      'qr_img': instance.qrImgUrl,
      'is_venueadmin': instance.isVenueAdmin,
      'is_gov': instance.isGovAgent,
      'dob': instance.dateOfBirth?.toIso8601String(),
      'is_locked': instance.isLocked,
    };
