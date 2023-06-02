import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/mode_controller.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../presentation/constants/colors.dart';

Map _source = {ConnectivityResult.none: false};
final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
String string = '';

class CheckConnect {
  static Future networkCheck() async {
     bool? isOnce;
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.

      // 3.
      if (string == "Mobile: Online" || string == "WiFi: Online") {
        // isOnce = false;
        ModeController.handleMode("online");
        if (isOnce != null) {
          showSimpleNotification(
            AppText(
                text: string,
                color: HexColor(backgroundColor),
                fontWeight: FontWeight.bold,
                size: 12),
            contentPadding: const EdgeInsets.all(10),
            slideDismiss: true,
            leading: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.transparent),
              child: Center(
                  child: SvgPicture.asset(
                'assets/icon/crown.svg',
                color: HexColor(backgroundColor),
              )),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppText(
                text: "your are back online",
                color: HexColor(backgroundColor),
              ),
            ),
            elevation: 10,
            background: string == "Mobile: Online" || string == "WiFi: Online"
                ? Colors.green
                : Colors.red,
            duration: const Duration(seconds: 5),
          );
        }
         ModeController.handleMode("online");
      } else {
        isOnce = true;
        showSimpleNotification(
          AppText(
              text: string,
              color: HexColor(backgroundColor),
              fontWeight: FontWeight.bold,
              size: 12),
          contentPadding: const EdgeInsets.all(10),
          slideDismiss: true,
          leading: Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.transparent),
            child: Center(
                child: SvgPicture.asset(
              'assets/icon/crown.svg',
              color: HexColor(backgroundColor),
            )),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: AppText(
              text: "your are $string",
              color: HexColor(backgroundColor),
            ),
          ),
          elevation: 10,
          background: string == "Mobile: Online" || string == "WiFi: Online"
              ? Colors.green
              : Colors.red,
          duration: const Duration(seconds: 5),
        );
        ModeController.handleMode("offline");
      }
    });
  }
}

class NetworkConnectivity {
  NetworkConnectivity._();
  static final _instance = NetworkConnectivity._();
  static NetworkConnectivity get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  // 1.
  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      print(result);
      _checkStatus(result);
    });
  }

// 2.
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
