import 'package:video_player/video_player.dart';

class PreloadModel {
  int? id;
  List<dynamic>? vod;
  VideoPlayerController? controller;

  PreloadModel({this.id, this.vod, this.controller});

  PreloadModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vod = json['vod'].cast<String>();
    controller = json['controller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vod'] = vod;
    data['controller'] = controller;
    return data;
  }
}