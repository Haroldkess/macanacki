import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';

class UpdateApp{
static final newVersion = NewVersion(
      androidId: 'com.thomas.macanacki',
      iOSId: ''
    );
  static Future<void>  basicStatusCheck(context) async {
    final status = await newVersion.getVersionStatus();

    if (status != null) {
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: "UPDATE!!!",
          dismissButtonText: "Skip",
          dialogText: "Please update the app from ${status.localVersion} to ${status.storeVersion}",
          dismissAction: () {
            SystemNavigator.pop();
          },
          updateButtonText: "Lets update",
        );
      }
    }
  }




}