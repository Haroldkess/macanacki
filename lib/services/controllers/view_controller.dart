
import 'package:http/http.dart' as http;
import 'package:makanaki/services/middleware/view_ware.dart';

class ViewController extends ViewWare {
  static Future<void> handleView(int postId) async {
    ViewWare view = ViewWare();
    view.viewFromApi(postId);
  }
}
