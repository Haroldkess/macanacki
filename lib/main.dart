import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/config/pay_ext.dart';
import 'package:macanacki/preload/preload_controller.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/onboarding/splash_screen.dart';
import 'package:macanacki/presentation/uiproviders/screen/chat_provider.dart';
import 'package:macanacki/presentation/widgets/routes/routes.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/IAUpdate.dart';
import 'package:macanacki/services/controllers/login_controller.dart';
import 'package:macanacki/services/controllers/save_media_controller.dart';
import 'package:macanacki/services/middleware/post_security.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:macanacki/services/provider_init.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:intl/intl.dart';
import 'presentation/uiproviders/screen/tab_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // Initialize inApp Store
  PayExt.initializeStore();

  dotenv.load(fileName: "secret.env");
  Platform.isAndroid ? IAUpdate().checkForUpdate() : null;
  // await Database.initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  //await PurchaseExt.init();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: HexColor(backgroundColor)));
  Get.put(VideoWare("", 0, false, 0));
  Get.put(VideoWareHome("", 0, false, 0));
  Get.put(MediaDownloadProgress());
  Get.put(PersistentNavController());
  Get.put(PostSecurity());
  Get.put(scrolNotify());
  Get.put(ChatProvider());
  Get.put(scrolNotifyPublic());
  Get.put<PreloadController>(PreloadController());
  PreloadController.to.clear();

  try {
    // Configure inApp SDK
    await PayExt.configureSDK();
  } catch (e) {}

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        //  systemNavigationBarColor: Colors.transparent,
        //systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light
        // systemStatusBarContrastEnforced: true
        ));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = textWhite;
    configs.appBarBackgroundColor = HexColor(darkColor);
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.cropFeatureEnabled = true;
    configs.stickerFeatureEnabled = false;
    configs.cameraPickerModeEnabled = Platform.isIOS ? false : true;
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
            navigatorKey: navigatorKey,
            title: 'Macanacki',
            theme: ThemeData(
                primaryColor: HexColor(backgroundColor),
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: Colors.transparent),
                iconButtonTheme: IconButtonThemeData(
                    style: ButtonStyle(
                        iconColor: MaterialStateProperty.all(Colors.black))),
                primaryIconTheme: IconThemeData(color: Colors.black)),
            home: const Splash(),
            initialRoute: '/',
            routes: getApplicationRoutes(),
          ),
        ));
  }
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: AppText(
          text: "Checking out notification",
          color: Colors.purple,
        ),
      ),
      body: Center(
        child: AppText(
          text: "NOTIFICATION WORKS",
          color: secondaryColor,
        ),
      ),
    );
  }
}
