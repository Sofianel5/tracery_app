import 'package:json_annotation/json_annotation.dart';
import 'package:tracery_app/models/anon_user_model.dart';
import 'package:tracery_app/models/venue_model.dart';
part 'thread_from_person_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ThreadFromPerson {
  ThreadFromPerson({this.threadId, this.to, this.time, this.toConfirmed});

  @JsonKey(name: "thread_id")
  String threadId;

  @JsonKey(name: "_to")
  Venue to;

  @JsonKey(name: "_from")
  AnonUser from;

  DateTime time;

  @JsonKey(name: "from_confirmed")
  bool fromConfirmed;

  @JsonKey(name: "to_confirmed")
  bool toConfirmed;

  factory ThreadFromPerson.fromJson(Map<String, dynamic> json) => _$ThreadFromPersonFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadFromPersonToJson(this);
}