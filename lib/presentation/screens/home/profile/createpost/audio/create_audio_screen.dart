import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/operations_ext.dart';
import 'package:path/path.dart' hide context;
import 'package:provider/provider.dart';
import '../../../../../../services/controllers/button_controller.dart';
import '../../../../../../services/controllers/create_post_controller.dart';
import '../../../../../../services/middleware/button_ware.dart';
import '../../../../../../services/middleware/create_post_ware.dart';
import '../../../../../../services/middleware/user_profile_ware.dart';
import '../../../../../allNavigation.dart';
import '../../../../../widgets/avatar.dart';
import '../../../../../widgets/form.dart';
import '../../../../../widgets/loader.dart';
import '../../../../../widgets/snack_msg.dart';
import '../../../../../widgets/text.dart';
import '../add_button.dart';
import '../add_button_individual.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  TextEditingController buttonController = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ButtonController.retrievButtonsController(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    CreatePostWare stream = context.watch<CreatePostWare>();

    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    addTitle(
      BuildContext cont,
      TextEditingController songTitle,
    ) async {
      return showModalBottomSheet(
          context: cont,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        AppText(
                          text: "🎵 Add song title",
                          size: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xFFF5F2F8),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.7,
                                  child: AppForm(
                                    borderRad: 5.0,
                                    backColor: Colors.transparent,
                                    hint: "Enter song title",
                                    hintColor: HexColor("#C0C0C0"),
                                    controller: songTitle,
                                    fontSize: 13,
                                    textInputType: TextInputType.text,
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        title = songTitle;
                                      });
                                      PageRouting.popToPage(context);
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 5),
                                          child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    "assets/icon/Send.svg",
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ])),
                  )
                ],
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: backgroundSecondary,
      body: Column(
        children: [
          SafeArea(
            child: Container(
              height: Get.height * 0.06,
              width: Get.width,
              color: HexColor(backgroundColor),
              padding: EdgeInsets.symmetric(horizontal: 12),
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: HexColor("#C0C0C0"),
                    ),
                    onPressed: () {
                      PageRouting.popToPage(context);
                    },
                  ),
                  AppText(
                    text: "New Post",
                    color: textWhite,
                    fontWeight: FontWeight.w600,
                    size: 17,
                  ),
                  Row(
                    children: [
                      // user.userProfileModel.gender == "Business"
                      //     ? OutlinedButton(
                      //         style: OutlinedButton.styleFrom(
                      //             backgroundColor: HexColor("#00B074"),
                      //             fixedSize: Size(86, 0),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(16),
                      //             ),
                      //             side: BorderSide(
                      //                 color: HexColor("#00B074"),
                      //                 width: 1.0,
                      //                 style: BorderStyle.solid)),
                      //         onPressed: () =>
                      //             buttonModal(context, buttonController),
                      //         child: AppText(
                      //           text: "Add Button",
                      //           scaleFactor: 0.6,
                      //           color: HexColor(backgroundColor),
                      //           fontWeight: FontWeight.w600,
                      //         ))
                      //     : OutlinedButton(
                      //         style: OutlinedButton.styleFrom(
                      //             backgroundColor: HexColor("#00B074"),
                      //             fixedSize: Size(86, 0),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(16),
                      //             ),
                      //             side: BorderSide(
                      //                 color: HexColor("#00B074"),
                      //                 width: 1.0,
                      //                 style: BorderStyle.solid)),
                      //         onPressed: () => buttonIndividualModal(
                      //             context, buttonController),
                      //         child: AppText(
                      //           text: "Add Button",
                      //           scaleFactor: 0.6,
                      //           color: HexColor(backgroundColor),
                      //           fontWeight: FontWeight.w600,
                      //         )),
                      // const SizedBox(
                      //   width: 5,
                      // ),

                      stream.loadStatusAudio
                          ? Loader(color: textPrimary)
                          : TextButton(
                              onPressed: () {
                                _submit(context);
                              },
                              child: AppText(
                                text: "Post",
                                size: 14,
                                color: textWhite,
                                fontWeight: FontWeight.w600,
                              ))
                      // stream.loadStatusAudio
                      //     ? Loader(color: HexColor(primaryColor))
                      //     : OutlinedButton(
                      //         style: OutlinedButton.styleFrom(
                      //             backgroundColor: HexColor(primaryColor),
                      //             fixedSize: Size(68, 0),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(16),
                      //             ),
                      //             side: BorderSide(
                      //                 color: HexColor(primaryColor),
                      //                 width: 1.0,
                      //                 style: BorderStyle.solid)),
                      //         onPressed: () => _submit(context),
                      //         child: AppText(
                      //           text: "Post",
                      //           scaleFactor: 0.6,
                      //           color: HexColor(backgroundColor),
                      //           fontWeight: FontWeight.w600,
                      //         ))
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Avatar(
                              image: user.userProfileModel.profilephoto ?? "",
                              radius: 25),
                        ],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          AppText(
                            text: user.userProfileModel.username ?? "",
                            color: textWhite,
                            fontWeight: FontWeight.bold,
                            size: 14,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          InkWell(
                            onTap: () {
                              if (user.userProfileModel.gender == "Business") {
                                buttonModal(context, buttonController);
                              } else {
                                buttonIndividualModal(
                                    context, buttonController);
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      AppText(
                                        text: "Add Button",
                                        scaleFactor: 0.6,
                                        color: textWhite,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                AudioView(
                  title: "Add Audio File",
                  icon: Icons.audiotrack_rounded,
                  description: stream.audioFile == null
                      ? "select the audio file you wish to upload"
                      : "🎵 ${basename(stream.audioFile!.path)}",
                  tap: () {
                    Operations.pickAudio(context);
                  },
                  added: stream.audioFile == null ? false : true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: AudioView(
                      title: "Add Audio Cover",
                      icon: Icons.photo,
                      description: stream.audioCoverFile == null
                          ? "Add a cover photo to the audio file"
                          : "You have added a cover photo",
                      tap: () {
                        Operations.pickCoverOfAudio(context);
                      },
                      added: stream.audioCoverFile == null ? false : true),
                ),
                AudioView(
                    title: "Add Audio title",
                    icon: Icons.description_outlined,
                    description: title.text.isEmpty
                        ? "Add a title to the audio file"
                        : title.text,
                    tap: () {
                      addTitle(context, title);
                    },
                    added: title.text.isEmpty ? false : true),
              ],
            ),
          ))
        ],
      ),
    );
  }

  _submit(BuildContext context) async {
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    if (title.text.isEmpty) {
      showToast2(context, "Add audio title", isError: true);
      return;
    }

    if (user.userProfileModel.gender == "Business") {
      if (button.url.isNotEmpty) {
        if (button.url.contains("https://") || button.name == "Call Now") {
          await CreatePostController.createAudioPostController(
              context, title.text);
        } else {
          showToast2(context, "Url must contain https://", isError: true);
        }
      } else {
        await CreatePostController.createAudioPostController(
            context, title.text);
      }
    } else {
      // button.addIndex(0);
      // button.addUrl("");
      await CreatePostController.createAudioPostController(context, title.text);
    }
  }
}

class AudioView extends StatelessWidget {
  final String? title;
  final String? description;
  final IconData? icon;
  VoidCallback tap;
  bool added;
  AudioView(
      {super.key,
      this.title,
      this.description,
      this.icon,
      required this.tap,
      required this.added});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: tap,
        child: Container(
          height: 100,
          width: Get.width,
          decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: backgroundSecondary,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: title ?? "",
                        color: textWhite,
                        fontWeight: FontWeight.w500,
                        size: 17,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: AppText(
                          text: description ?? "",
                          color: textPrimary,
                          fontWeight: FontWeight.w500,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 1, color: added ? Colors.green : Colors.red)),
                  child: Center(
                    child: Icon(added ? Icons.done : Icons.clear,
                        size: 15, color: added ? Colors.green : Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
