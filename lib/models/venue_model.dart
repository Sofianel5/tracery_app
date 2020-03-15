import 'package:json_annotation/json_annotation.dart';
import 'package:tracery_app/models/coordinates_model.dart';
part 'venue_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Venue {
  Venue({this.title, this.coordinates, this.publicId, this.securityValue});
  String title;
  Coordinates coordinates;

  @JsonKey(name: 'security_level')
  String securityLevel;

  @JsonKey(name: 'public_id')
  String publicId;

  @JsonKey(name: 'security_value')
  double securityValue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
  Map<String, dynamic> toJson() => _$VenueToJson(this);
}