import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/presentation/widgets/feed_views/single_posts.dart';

import '../../../main.dart';
import '../../screens/home/Feed/single_feed_post.dart';
import '../../screens/onboarding/splash_screen.dart';
import '../../screens/userprofile/testing_profile.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'splash': (BuildContext context) => const Splash(),
    '/post': (BuildContext context) => SingleFeedPost(),
    '/profile': (BuildContext contex) => const TestProfile(
          username: "",
          extended: false,
          isFromRoute: true,
        ),
  };
}
