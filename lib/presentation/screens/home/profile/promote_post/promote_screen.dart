import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/screens/home/profile/promote_post/duration_modal.dart';
import 'package:macanacki/presentation/screens/home/profile/promote_post/price_modal.dart';
import 'package:macanacki/presentation/screens/home/profile/promote_post/select_post.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/ads_controller.dart';
import 'package:macanacki/services/middleware/ads_ware.dart';
import 'package:provider/provider.dart';
import '../../../../../model/ads_price_model.dart';
import '../../../../../model/profile_feed_post.dart';
import '../../../../../services/api_url.dart';
import '../../../../../services/controllers/payment_controller.dart';
import '../../../../../services/controllers/url_launch_controller.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/text.dart';
import '../profileextras/profile_action_buttons.dart';

class PromoteScreen extends StatefulWidget {
  final String? postId;
  const PromoteScreen({super.key, this.postId});
  @override
  State<PromoteScreen> createState() => _PromoteScreenState();
}

class _PromoteScreenState extends State<PromoteScreen> {
  var publicKey = 'pk_test_66374a59ec66f6c94391ed9b6a405cbf94432d5f';
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  bool iAgree = true;
  String choosenCountry = "";
  ProfileFeedDatum? post;
  @override
  void initState() {
    super.initState();
    // plugin.initialize(
    //     publicKey: publicKey);
         //dotenv.get('PUBLIC_KEY').toString()
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AdsController.retrievAdsController(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AdsWare ware = Provider.of<AdsWare>(context, listen: false);
      ware.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    AdsWare stream = context.watch<AdsWare>();
    FeedPostWare feed = context.watch<FeedPostWare>();
    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        title: AppText(
          text: 'Preview',
          fontWeight: FontWeight.w500,
          size: 22,
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: HexColor(backgroundColor),
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                AdsAction(
                    title: "select country ",
                    subTitle: choosenCountry.isEmpty
                        ? "Pick a country"
                        : choosenCountry,
                    name: "Audience",
                    SubName: "Choose your preferred country",
                    action: () async {
                      showCountryPicker(
                        context: context,
                        //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                        exclude: <String>['KN', 'MF'],
                        favorite: <String>['NG'],
                        //Optional. Shows phone code before the country name.
                        showPhoneCode: false,
                        onSelect: (Country country) {
                          print('Select country: ${country.name}');
                          setState(() {
                            choosenCountry = country.name;
                          });
                        },
                        // Optional. Sets the theme for the country list picker.
                        countryListTheme: CountryListThemeData(
                          // Optional. Sets the border radius for the bottomsheet.
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                          // Optional. Styles the search field.
                          inputDecoration: InputDecoration(
                            labelText: 'Search',
                            hintText: 'Start typing to search',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
                              ),
                            ),
                          ),
                          // Optional. Styles the text in the search field
                          searchTextStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                AdsAction(
                    title: "select budget  ",
                    subTitle:
                        "Price: N${convertToCurrency(stream.selected.price == null ? "0" : stream.selected.price.toString())}      Reach: ${convertToCurrency(stream.selected.reach ?? "0")}",
                    name: "Budget & Reach",
                    SubName: "Select your preferred budget and reach ",
                    action: () {
                      priceOptionModal(context);
                    }),
                const SizedBox(
                  height: 20,
                ),
                AdsAction(
                    title: "select Duration  ",
                    subTitle: stream.duration,
                    name: "Ad Duration",
                    SubName: "Select Ad Duration ",
                    action: () {
                      durationOptionModal(context);
                    }),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    post == null
                        ? SizedBox.shrink()
                        : Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            post!.media!.first
                                                .replaceAll('\\', '/'),
                                          ),
                                          fit: BoxFit.fill,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text:
                                        post == null ? '' : post!.description!,
                                    fontWeight: FontWeight.w500,
                                    size: 13,
                                    color: HexColor("#797979"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    ProfileActionButton(
                      icon: "assets/icon/post.svg",
                      onClick: () async {
                        var data =
                            await selectPost(context, feed.profileFeedPosts);
                        if (data != null) {
                          setState(() {
                            post = data;
                          });
                        }
                      },
                      color: "#F94C84",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      text: 'select post',
                      fontWeight: FontWeight.w500,
                      size: 16,
                      color: HexColor("#797979"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Checkbox(
                        fillColor:
                            MaterialStatePropertyAll(HexColor(primaryColor)),
                        value: iAgree,
                        onChanged: ((value) {
                          setState(() {
                            iAgree = value!;
                          });
                        })),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: width * 0.75,
                      child: RichText(
                        text: TextSpan(
                            text: "I consent to the use of MacaNacki ",
                            style: GoogleFonts.leagueSpartan(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: HexColor(darkColor),
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: 12)),
                            children: [
                              TextSpan(
                                text: "Terms of Use",
                                style: GoogleFonts.leagueSpartan(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: HexColor(primaryColor),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 12)),
                                recognizer: tapGestureRecognizer
                                  ..onTap = () async {
                                    await UrlLaunchController
                                        .launchInWebViewOrVC(Uri.parse(terms));
                                  },
                              ),
                              TextSpan(
                                text: " and ",
                                style: GoogleFonts.leagueSpartan(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: HexColor(darkColor),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 12)),
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: GoogleFonts.leagueSpartan(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: HexColor(primaryColor),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 12)),
                                recognizer: tapGestureRecognizer
                                  ..onTap = () async {
                                    await UrlLaunchController
                                        .launchInWebViewOrVC(Uri.parse(terms));
                                  },
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                stream.loadStatus2
                    ? Loader(color: HexColor(primaryColor))
                    : AppButton(
                        width: 0.9,
                        height: 0.06,
                        color: primaryColor,
                        text: "Continue",
                        backColor: primaryColor,
                        curves: buttonCurves * 5,
                        textColor: backgroundColor,
                        onTap: () async {
                          if (widget.postId == null) {
                            if (post == null) {
                              showToast2(context,
                                  "Please select the post you want to promote");
                              return;
                            } else {
                              _submit(context, post!.id!);
                            }
                          } else {
                            _submit(context, widget.postId);
                          }
                        })
              ],
            ),
          )),
    );
  }

  _submit(context, id) async {
    AdsWare action = Provider.of<AdsWare>(context, listen: false);
    if (action.adsPrice.isEmpty) {
      showToast2(context, "Failed to get the ads price please try again");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        AdsController.retrievAdsController(context);
      });
      return;
    }
    if (choosenCountry.isEmpty) {
      showToast2(context, "Select country", isError: true);
      return;
    } else if (action.selected.price == null) {
      showToast2(context, "Add budget", isError: true);
      return;
    } else if (action.duration == "select") {
      showToast2(context, "Add duration", isError: true);
      return;
    } else {
      SendAdModel data = SendAdModel(
          country: choosenCountry,
          postId: id.toString(),
          duration: action.duration,
          planId: action.selected.id.toString());
      AdsController.sendAdRequeest(context, data);
    }
  }
}

class AdsAction extends StatelessWidget {
  String title;
  String subTitle;
  VoidCallback? action;
  String name;
  String SubName;

  AdsAction(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.action,
      required this.name,
      required this.SubName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //   showMeOptionModal(context);
      },
      child: Container(
        //  height: 87,
        width: 402,
        color: HexColor(backgroundColor),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: name,
                            color: HexColor("#0C0C0C"),
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          AppText(
                            text: SubName,
                            color: HexColor("#0C0C0C"),
                            size: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: action,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: title,
                              color: HexColor("#0C0C0C"),
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AppText(
                              text: subTitle,
                              color: HexColor("#818181"),
                              size: 13,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icon/fowardarrow.svg"),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
