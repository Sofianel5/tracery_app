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
  String puid;

  @JsonKey(name: 'security_level')
  int securityLevel;

  @JsonKey(name: 'qr_img')
  String qrImgUrl;

  @JsonKey(name: 'is_venueadmin')
  bool isVenueAdmin; 

  @JsonKey(name: 'is_gov')
  bool isGovAgent; 

  @JsonKey(name: 'dob')
  DateTime dateOfBirth;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  String toString() {
    return firstName + " " + lastName;
  }
}