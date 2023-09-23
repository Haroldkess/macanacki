import 'dart:developer';
import 'package:in_app_update/in_app_update.dart';

class IAUpdate {
  //
  // AppUpdateInfo? _updateInfo;
  //
  // bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    log('checking if update available');
    InAppUpdate.checkForUpdate().then((info) {
        // _updateInfo = info;
        if(info.updateAvailability == UpdateAvailability.updateAvailable){
          InAppUpdate.performImmediateUpdate()
              .catchError((e){});
        } else if(info.updateAvailability == UpdateAvailability.updateAvailable){
          InAppUpdate.startFlexibleUpdate().then((_) {
            InAppUpdate.completeFlexibleUpdate().then((_) {
            }).catchError((e) {});
          }).catchError((e) {});
        }
    }).catchError((e) {
    });
  }
}
