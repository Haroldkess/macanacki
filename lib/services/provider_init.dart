import 'package:makanaki/presentation/uiproviders/dob/dob_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/card_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/comment_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/find_people_provider.dart';
import 'package:makanaki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:makanaki/services/middleware/action_ware.dart';
import 'package:makanaki/services/middleware/button_ware.dart';
import 'package:makanaki/services/middleware/chat_ware.dart';
import 'package:makanaki/services/middleware/create_post_ware.dart';
import 'package:makanaki/services/middleware/edit_profile_ware.dart';
import 'package:makanaki/services/middleware/facial_ware.dart';
import 'package:makanaki/services/middleware/feed_post_ware.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:makanaki/services/middleware/notification_ware..dart';
import 'package:makanaki/services/middleware/otp_ware.dart';
import 'package:makanaki/services/middleware/plan_ware.dart';
import 'package:makanaki/services/middleware/registeration_ware.dart';
import 'package:makanaki/services/middleware/search_ware.dart';
import 'package:makanaki/services/middleware/swipe_ware.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:makanaki/services/middleware/view_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../presentation/uiproviders/buttons/button_state.dart';
import '../presentation/uiproviders/screen/gender_provider.dart';
import 'middleware/login_ware.dart';

class InitProvider {
  static List<SingleChildWidget> providerInit() {
    final List<SingleChildWidget> provided = [
      ChangeNotifierProvider(
        create: (context) => ButtonState(),
      ),
      ChangeNotifierProvider(
        create: (context) => GenderProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DobProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => TabProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => FindPeopleProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CardProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => RegisterationWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => Temp(),
      ),
      ChangeNotifierProvider(
        create: (context) => OtpWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => genderWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => FacialWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => LoginWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProfileWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => CreatePostWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => FeedPostWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => ActionWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => StoreComment(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => SwipeWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => ChatWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlanWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => NotificationWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => ViewWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => ButtonWare(),
      ),
      ChangeNotifierProvider(
        create: (context) => EditProfileWare(),
      ),
    ];

    return provided;
  }
}
