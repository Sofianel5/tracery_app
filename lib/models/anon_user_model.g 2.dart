// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anon_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnonUser _$AnonUserFromJson(Map<String, dynamic> json) {
  return AnonUser(
    puid: json['public_id'] as String,
  )
    ..securityLevel = json['security_level'] as String
    ..securityValue = (json['security_value'] as num)?.toDouble()
    ..isLocked = json['is_locked'] as bool
    ..passtoken = json['passtoken'] as String;
}

Map<String, dynamic> _$AnonUserToJson(AnonUser instance) => <String, dynamic>{
      'public_id': instance.puid,
      'security_level': instance.securityLevel,
      'security_value': instance.securityValue,
      'is_locked': instance.isLocked,
      'passtoken': instance.passtoken,
    };
