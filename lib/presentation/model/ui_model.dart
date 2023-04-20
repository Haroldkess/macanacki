import 'package:makanaki/presentation/constants/params.dart';

class GenderSelectModel {
  int id;
  String gender;
  bool selected;

  GenderSelectModel({
    required this.id,
    required this.gender,
    required this.selected,
  });
}

List<GenderSelectModel> genderModel = [
  GenderSelectModel(id: 0, gender: "Man", selected: true),
  GenderSelectModel(id: 1, gender: "Woman", selected: false),
  GenderSelectModel(id: 2, gender: "Business", selected: false),
];

class KycInfo {
  String title;
  String subTitle;

  KycInfo({
    required this.subTitle,
    required this.title,
  });
}

List<KycInfo> info = [
  KycInfo(
      subTitle:
          'Make sure the environment you are using has enough light. Avoid backlighting and glare',
      title: 'Good Lighting'),
  KycInfo(
      subTitle:
          'Be directly infront of the camera, make shure you are NOT wearing hat, sunglasses or face covering',
      title: 'Show Your Full Face'),
];

class SocialComments {
  String image;
  String comment;
  String timeAgo;
  String userName;
  String likeNum;

  SocialComments(
      {required this.comment,
      required this.image,
      required this.likeNum,
      required this.timeAgo,
      required this.userName});
}

List<SocialComments> comments = [
  SocialComments(
      comment:
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
      image: url,
      likeNum: "33",
      timeAgo: "32 mins",
      userName: "Wellington"),
  SocialComments(
      comment:
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
      image: url,
      likeNum: "33",
      timeAgo: "32 mins",
      userName: "Peter"),
  SocialComments(
      comment:
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
      image: url,
      likeNum: "33",
      timeAgo: "32 mins",
      userName: "Sara"),
  SocialComments(
      comment:
          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.",
      image: url,
      likeNum: "33",
      timeAgo: "32 mins",
      userName: "Sara"),
];

class FeedPostOption {
  String name;
  int id;

  FeedPostOption({
    required this.id,
    required this.name,
  });
}

List<FeedPostOption> feedOption = [
  FeedPostOption(id: 0, name: "Download"),
  FeedPostOption(id: 1, name: "Report"),
  FeedPostOption(id: 2, name: "Report Abuse"),
];

List<FeedPostOption> chatOption = [
 // FeedPostOption(id: 0, name: "Unmatch"),
  FeedPostOption(id: 1, name: "Block User"),
  FeedPostOption(id: 2, name: "Report Abuse"),
];

class SubPlans {
  String duration;
  String amount;
  String discount;
  bool isPopular;

  SubPlans({
    required this.amount,
    required this.discount,
    required this.duration,
    required this.isPopular,
  });
}

List<SubPlans> subs = [
  SubPlans(
      amount: "NGN 900/mo",
      discount: "",
      duration: "3 Months",
      isPopular: false),
  SubPlans(
      amount: "NGN 800/mo",
      discount: "SAVE 20%",
      duration: "6 Months",
      isPopular: true),
  SubPlans(
      amount: "NGN 600/mo",
      discount: "SAVE 30%",
      duration: "12 Months",
      isPopular: false),
];

List<String> verificationInfo = [
  "See New Match Requests",
  "Send message to unmatched users"
];

List<String> matches = [
  "Emelda",
  "Brenda",
  "Lilly",
  "Capito",
  "Emelda",
  "Brenda",
  "Lilly",
  "Capito",
];

class AppUser {
  String name;
  String imageUrl;
  String msg;
  String time;
  bool read;
  String age;

  AppUser(
      {required this.imageUrl,
      required this.msg,
      required this.name,
      required this.time,
      required this.read,
      required this.age});
}

List<AppUser> chatUsers = [
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: true,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
];

List<AppUser> matchedUsers = [
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: true,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: true,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: true,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
  AppUser(
      imageUrl: url,
      msg: "Hoping we have a nice outting time!",
      name: "Jennie",
      time: "9:30",
      read: false,
      age: "23"),
];

class ChatModel {
  String msg;
  String time;
  bool isMine;

  ChatModel({
    required this.isMine,
    required this.msg,
    required this.time,
  });
}

List<ChatModel> chatModel = [
  ChatModel(isMine: false, msg: "Hi Jenny...", time: "20:00"),
  ChatModel(
      isMine: false,
      msg:
          "Hi Jake, how are you? I saw on the app that we’ve crossed paths several times this week 😄",
      time: "21:55"),
  ChatModel(
      isMine: true,
      msg:
          "May name is Adamu, I am 24 years oold. I feel greate to meet you here3. I will like to konw more about you. If you dont miind",
      time: "3:02 PM"),
];

class SelectGender {
  String text;
  bool isSelected;
  int id;
  SelectGender(
      {required this.text, required this.id, required this.isSelected});
}

class LocationSettings {
  String title;
  String subtitle;
  bool isSelected;
  int id;
  LocationSettings(
      {required this.title,
      required this.id,
      required this.isSelected,
      required this.subtitle});
}

class WhoYouSee {
  String title;
  String subtitle;
  bool isSelected;
  int id;
  WhoYouSee(
      {required this.title,
      required this.id,
      required this.isSelected,
      required this.subtitle});
}

class CommunitySocialHandle {
  String title;
  String iconPath;
  int id;
  CommunitySocialHandle({
    required this.title,
    required this.id,
    required this.iconPath,
  });
}

class ShowMe {
  String title;
  int id;
  bool isSelected;
  ShowMe({required this.title, required this.id, required this.isSelected});
}

List<CommunitySocialHandle> socialHandles = [
  CommunitySocialHandle(
      title: "Twitter", id: 0, iconPath: "assets/icon/twitter.svg"),
  CommunitySocialHandle(
      title: "Facebook", id: 1, iconPath: "assets/icon/facebook.svg"),
  CommunitySocialHandle(
      title: "Instagram", id: 2, iconPath: "assets/icon/instagram.svg"),
  CommunitySocialHandle(
      title: "LinkIn", id: 3, iconPath: "assets/icon/Linkedin.svg"),
  CommunitySocialHandle(
      title: "Telegram", id: 4, iconPath: "assets/icon/telegram.svg"),
];

class AppNotification {
  String image;
  String title;
  String subTitle;
  String time;
  int id;
  bool isRequest;
  bool isVerify;

  AppNotification(
      {required this.id,
      required this.image,
      required this.subTitle,
      required this.time,
      required this.title,
      required this.isRequest,
      required this.isVerify});
}

List<AppNotification> appNotification = [
  AppNotification(
      id: 0,
      image: url,
      subTitle: "Jennie wants to match with you",
      time: "12 mins ago",
      title: "Jennie Accepted you match Request",
      isRequest: false,
      isVerify: false),
  AppNotification(
      id: 1,
      image: url,
      subTitle: "Jennie wants to match with you",
      time: "12 mins ago",
      title: "Jennie Accepted you match Request",
      isRequest: false,
      isVerify: false),
  AppNotification(
      id: 2,
      image: url,
      subTitle: "Jennie wants to match with you",
      time: "12 mins ago",
      title: "Jennie Accepted you match Request",
      isRequest: false,
      isVerify: false),
  AppNotification(
      id: 3,
      image: "assets/icon/key.svg",
      subTitle: "Get verified by uploading a valid ID Card",
      time: "12 mins ago",
      title: "Verify your Identity ",
      isRequest: false,
      isVerify: true),
  AppNotification(
      id: 4,
      image: "assets/icon/crown.svg",
      subTitle: "Marrialie Sent you match request",
      time: "12 mins ago",
      title: "Verify your Identity ",
      isRequest: true,
      isVerify: false),
];

class Follower {
  String name;
  String age;
  bool isOnline;
  String imgUrl;
  bool isMatched;

  Follower(
      {required this.age,
      required this.imgUrl,
      required this.isMatched,
      required this.isOnline,
      required this.name});
}

List<Follower> follower = [
  Follower(
      age: "23", imgUrl: url, isMatched: false, isOnline: true, name: "Jennie"),
  Follower(
      age: "23", imgUrl: url, isMatched: true, isOnline: true, name: "Jennie"),
  Follower(
      age: "23", imgUrl: url, isMatched: false, isOnline: true, name: "Jennie"),
  Follower(
      age: "23", imgUrl: url, isMatched: false, isOnline: true, name: "Jennie"),
  Follower(
      age: "23", imgUrl: url, isMatched: false, isOnline: true, name: "Jennie"),
];
