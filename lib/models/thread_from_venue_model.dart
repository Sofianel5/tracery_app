import 'package:json_annotation/json_annotation.dart';
import 'package:tracery_app/models/venue_model.dart';
part 'thread_from_venue_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreadFromVenueModel {
  ThreadFromVenueModel({this.threadId, this.from, this.time, this.toConfirmed});

  @JsonKey(name: "thread_id")
  String threadId;

  @JsonKey(name: "_from")
  Venue from;

  DateTime time;

  @JsonKey(name: "from_confirmed")
  bool fromConfirmed;

  @JsonKey(name: "to_confirmed")
  bool toConfirmed;

  factory ThreadFromVenueModel.fromJson(Map<String, dynamic> json) => _$ThreadFromVenueModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadFromVenueModelToJson(this);
}