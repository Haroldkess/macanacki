import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/widgets/debug_emitter.dart';

import '../../model/asset_data.dart';
import '../../model/video_data.dart';
import '../../presentation/constants/string.dart';

class MUXClient {
  Dio _dio = Dio();

  /// Method for configuring Dio, the authorization is done from
  /// the API server
  initializeDio() {
    BaseOptions options = BaseOptions(
      baseUrl: muxServerUrl,
      connectTimeout: 80000,
      receiveTimeout: 50000,
      headers: {
        "Content-Type": contentType, // application/json
      },
    );
    _dio = Dio(options);
  }

  /// Method for storing a video to MUX, by passing the [videoUrl].
  ///
  /// Returns the `VideoData`.
  Future<VideoData?> storeVideo({String? videoUrl}) async {
    Response response;

    try {
      response = await _dio.post(
        "/assets",
        data: {
          "videoUrl": videoUrl,
        },
      );
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to store video on MUX');
    }

    if (response.statusCode == 200) {
      VideoData videoData = VideoData.fromJson(response.data);

      String? status = videoData.data!.status;

      while (status == 'preparing') {
        print('check');
        await Future.delayed(Duration(seconds: 1));
        videoData = (await checkPostStatus(videoId: videoData.data!.id))!;
        status = videoData.data!.status;
      }

      // print('Video READY, id: ${videoData.data.id}');

      return videoData;
    }

    return null;
  }

  /// Method for tracking the status of video storage on MUX.
  ///
  /// Returns the `VideoData`.
  Future<VideoData?> checkPostStatus({String? videoId}) async {
    try {
      Response response = await _dio.get(
        "/asset",
        queryParameters: {
          'videoId': videoId,
        },
      );

      if (response.statusCode == 200) {
        VideoData videoData = VideoData.fromJson(response.data);

        return videoData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to check status');
    }

    return null;
  }

  Future<VideoData?> deleteAsset({String? videoId}) async {
    try {
      Response response = await _dio.delete(
        "/asset",
        queryParameters: {
          'videoId': videoId,
        },
      );
      emitter(response.statusCode.toString());
      if (response.statusCode == 200) {
        emitter("deleted");
        //    VideoData videoData = VideoData.fromJson(response.data);

        return null;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to check status');
    }

    return null;
  }

  /// Method for retrieving the entire asset list.
  ///
  /// Returns the `AssetData`.
  Future<AssetData?> getAssetList() async {
    try {
      Response response = await _dio.get(
        "/assets",
      );

      if (response.statusCode == 200) {
        AssetData assetData = AssetData.fromJson(response.data);

        return assetData;
      }
    } catch (e) {
      print('Error starting build: $e');
      throw Exception('Failed to retireve videos from MUX');
    }

    return null;
  }
}
