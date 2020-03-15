import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  User({
    this.email,
    this.firstName,
    this.lastName,
    this.puid,
  });
  String email;

  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'last_name')
  String lastName;

  @JsonKey(name: 'public_id')
  String puid;

  @JsonKey(name: 'security_level')
  String securityLevel;

  @JsonKey(name: 'security_value')
  double securityValue;

  @JsonKey(name: 'qr_img')
  String qrImgUrl;

  @JsonKey(name: 'is_venueadmin')
  bool isVenueAdmin; 

  @JsonKey(name: 'is_gov')
  bool isGovAgent; 

  @JsonKey(name: 'dob')
  DateTime dateOfBirth;

  @JsonKey(name: "is_locked")
  bool isLocked; 

  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  String toString() {
    return firstName + " \n" + lastName + " \n" + email + " \n" + puid + " \n" + securityLevel + " \n" + securityValue.toString() + " \n" + qrImgUrl + " \n";
  }
}