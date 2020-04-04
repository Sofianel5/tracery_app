import 'package:json_annotation/json_annotation.dart';
part 'anon_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnonUser {
  AnonUser({
    this.puid,
  });

  @JsonKey(name: 'public_id')
  String puid;

  @JsonKey(name: 'security_level')
  String securityLevel;

  @JsonKey(name: 'security_value')
  double securityValue;

  @JsonKey(name: "is_locked")
  bool isLocked; 

  String passtoken;

  
  factory AnonUser.fromJson(Map<String, dynamic> json) => _$AnonUserFromJson(json);
  Map<String, dynamic> toJson() => _$AnonUserToJson(this);
  String toString() {
    return puid + " \n" + securityLevel + " \n" + securityValue.toString() + " \n";
  }
}