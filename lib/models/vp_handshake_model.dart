import 'package:json_annotation/json_annotation.dart';
import 'package:tracery_app/models/venue_model.dart';
part 'vp_handshake_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VenuePeerHandshake {
  VenuePeerHandshake({this.from, this.time});
  @JsonKey(name: "venue")
  Venue from;

  DateTime time;

  factory VenuePeerHandshake.fromJson(Map<String, dynamic> json) => _$VenuePeerHandshakeFromJson(json);
  Map<String, dynamic> toJson() => _$VenuePeerHandshakeToJson(this);
}