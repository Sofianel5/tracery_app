import 'package:json_annotation/json_annotation.dart';
import 'package:tracery_app/models/anon_user_model.dart';
import 'package:tracery_app/models/venue_model.dart';
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

  bool isPrivate;

  @JsonKey(name: 'dob')
  DateTime dateOfBirth;

  @JsonKey(name: "is_locked")
  bool isLocked; 

  @JsonKey(name: "anon_user")
  AnonUser anonUser;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  String toString() {
    return firstName + " \n" + lastName + " \n" + email + " \n" + puid + " \n" + securityLevel + " \n" + securityValue.toString() + " \n" + qrImgUrl + " \n";
  }
}