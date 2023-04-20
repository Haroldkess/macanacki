
import 'package:http/http.dart' as http;
import 'package:makanaki/services/middleware/mode_ware.dart';

class ModeController extends ModeWare {
  static Future<void> handleMode(String modeVal) async {
    ModeWare ware = ModeWare();
    ware.modeFromApi(modeVal);

  }
}
