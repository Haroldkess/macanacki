import 'dart:developer';

import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:macanacki/services/middleware/chat_ware.dart';
import 'package:macanacki/services/middleware/create_post_ware.dart';
import 'package:macanacki/services/middleware/search_ware.dart';
import 'package:macanacki/services/middleware/swipe_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../middleware/feed_post_ware.dart';
import '../middleware/user_profile_ware.dart';

const String emailKey = "email";

const String userNameKey = "userName";
const String passwordKey = "password";
const String genderId = "genderId";
const String facialUploadKey = "facial_upload";
const String photoKey = "photo";
const String temPhotoKey = "dpPhoto";
const String dobKey = "dob";
const String isLoggedInKey = "isLoggedIn";
const String tokenKey = "token";
const String dpKey = "dpKey";
const String deviceTokenKey = "deviceTokenKey";
const String latitudeKey = "latitudeKey";
const String longitudeKey = "longitudeKey";
const String isFirstTimeKey = "isFirstTime";
const String countryKey = "countryKey";
const String stateKey = "stateKey";
const String cityKey = "cityKey";
const String categoryKey = "categoryKey";
const String categoryIdKey = "categoryIdKey";
const String isVerifiedKey = "isVerifiedKey";
const String isVerifiedFirstKey = "isVerifiedFirstKey";
const String bankAdded = "bankAdded";
const String bankName = "bankName";
const String accountNumber = "accountNumber";
const String bankshortName = "bankshortName";
const String accountName = "accountName";
const String bankInfo = "bankInfo";

Future runTask(context, [String? name, String? dp]) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  Temp temp = Provider.of<Temp>(context, listen: false);
  if (pref.containsKey(isFirstTimeKey)) {
    pref.setBool(isFirstTimeKey, false);
  } else {
    pref.setBool(isFirstTimeKey, true);
  }
  pref.setBool(isFirstTimeKey, true);

  if (pref.containsKey(userNameKey)) {
    temp.addUserName(pref.getString(userNameKey)!);
  }
  if (name != null) {
    temp.addUserName(name);
  }

  if (pref.containsKey(dpKey)) {
    temp.addDp(pref.getString(dpKey)!);
  }
  if (dp != null) {
    temp.addDp(dp);
  }

  log("All necessity done");
}

Future removeProviders(context) async {
  ActionWare action = Provider.of<ActionWare>(context, listen: false);
  ChatWare chat = Provider.of<ChatWare>(context, listen: false);
  CreatePostWare post = Provider.of<CreatePostWare>(context, listen: false);

  SearchWare search = Provider.of<SearchWare>(context, listen: false);
  SwipeWare swipe = Provider.of<SwipeWare>(context, listen: false);
  UserProfileWare profile =
      Provider.of<UserProfileWare>(context, listen: false);
  FeedPostWare feed = Provider.of<FeedPostWare>(context, listen: false);

  action.disposeValue();
  chat.disposeValue();
  post.disposeValue();
  search.disposeValue();
  swipe.disposeValue();
  profile.disposeValue();
  feed.disposeValue();

  action.dispose();
  chat.dispose();
  post.dispose();
  search.dispose();
  swipe.dispose();
  profile.dispose();
  feed.dispose();
}
