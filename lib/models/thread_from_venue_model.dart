import 'package:json_annotation/json_annotation.dart';
import 'package:tracery_app/models/anon_user_model.dart';
import 'package:tracery_app/models/venue_model.dart';
part 'thread_from_venue_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreadFromVenue {
  ThreadFromVenue({this.threadId, this.from, this.time, this.toConfirmed});

  @JsonKey(name: "thread_id")
  String threadId;

  @JsonKey(name: "_from")
  Venue from;

  @JsonKey(name: "_to")
  AnonUser to;

  DateTime time;

  @JsonKey(name: "from_confirmed")
  bool fromConfirmed;

  @JsonKey(name: "to_confirmed")
  bool toConfirmed;

  factory ThreadFromVenue.fromJson(Map<String, dynamic> json) => _$ThreadFromVenueFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadFromVenueToJson(this);

  String toString() {
    return threadId + "\n" + from.toString() + "\n" + to.toString() + "\n" + fromConfirmed.toString() + "\n" + toConfirmed.toString();
  }
}