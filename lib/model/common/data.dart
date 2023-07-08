import 'dart:convert';
import 'package:macanacki/model/common/playback_id.dart';
import 'package:macanacki/model/common/track.dart';

class Data {
  Data({
    this.setting,
    this.test,
    this.maxStoredFrameRate,
    this.status,
    this.tracks,
    this.id,
    this.maxStoredResolution,
    this.masterAccess,
    this.playbackIds,
    this.createdAt,
    this.duration,
    this.mp4Support,
    this.aspectRatio,
  });

  Settings? setting;
  bool? test;
  dynamic maxStoredFrameRate;
  String? status;
  List<Track>? tracks;
  String? id;
  String? maxStoredResolution;
  String? masterAccess;
  List<PlaybackId>? playbackIds;
  String? createdAt;
  dynamic duration;
  String? mp4Support;
  String? aspectRatio;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        setting: json["settings"] == null
            ? null
            : Settings.fromJson(json["settings"]),
        test: json["test"],
        maxStoredFrameRate: json["max_stored_frame_rate"],
        status: json["status"],
        tracks: json["tracks"] == null
            ? null
            : List<Track>.from(json["tracks"].map((x) => Track.fromJson(x))),
        id: json["id"],
        maxStoredResolution: json["max_stored_resolution"],
        masterAccess: json["master_access"],
        playbackIds: json["playback_ids"] == null
            ? null
            : List<PlaybackId>.from(
                json["playback_ids"].map((x) => PlaybackId.fromJson(x))),
        createdAt: json["created_at"],
        duration: json["duration"],
        mp4Support: json["mp4_support"],
        aspectRatio: json["aspect_ratio"],
      );

  Map<String, dynamic> toJson() => {
        "settings": setting?.toJson(),
        "test": test,
        "max_stored_frame_rate": maxStoredFrameRate,
        "status": status,
        "tracks": tracks == null
            ? null
            : List<dynamic>.from(tracks!.map((x) => x.toJson())),
        "id": id,
        "max_stored_resolution": maxStoredResolution,
        "master_access": masterAccess,
        "playback_ids": playbackIds == null
            ? null
            : List<dynamic>.from(playbackIds!.map((x) => x.toJson())),
        "created_at": createdAt,
        "duration": duration,
        "mp4_support": mp4Support,
        "aspect_ratio": aspectRatio,
      };
}

class Settings {
  String? url;

  Settings({this.url});
  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        url: json["url"],
      );
  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
