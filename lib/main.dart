import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/onboarding/splash_screen.dart';
import 'package:macanacki/services/controllers/IAUpdate.dart';
import 'package:macanacki/services/provider_init.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:intl/intl.dart';

void main() async {
  dotenv.load(fileName: "secret.env");
  Platform.isAndroid ? IAUpdate().checkForUpdate() : null;
  // await Database.initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: HexColor(backgroundColor)));

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = HexColor(backgroundColor);
    configs.appBarBackgroundColor = HexColor(darkColor);
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.cropFeatureEnabled = true;
    configs.stickerFeatureEnabled = false;
    configs.cameraPickerModeEnabled = true;
    configs.imagePreProcessingEnabled = true;
    configs.albumPickerModeEnabled = true;
    configs.filterFeatureEnabled = true;
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = true;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'Edit Image',
        icon: Icons.edit_rounded,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'Edit Image',
        icon: Icons.edit_attributes,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    return MultiProvider(
        providers: InitProvider.providerInit(),
        child: OverlaySupport(
          toastTheme: ToastThemeData(alignment: Alignment.center),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Macanacki',
            theme: ThemeData(
                primaryColor: HexColor(primaryColor),
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: Colors.black),
                iconButtonTheme: IconButtonThemeData(
                    style: ButtonStyle(
                        iconColor: MaterialStateProperty.all(Colors.black))),
                primaryIconTheme: IconThemeData(color: Colors.black)),
            home: UpgradeAlert(
                upgrader: Upgrader(
                    dialogStyle: Platform.isIOS
                        ? UpgradeDialogStyle.cupertino
                        : UpgradeDialogStyle.material,
                    debugLogging: false),
                child: const Splash()),
          ),
        ));
  }
}
