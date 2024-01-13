import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/add_button.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/caption_form.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/video_holder.dart';
import 'package:macanacki/presentation/widgets/avatar.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/hexagon_avatar.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/button_controller.dart';
import 'package:macanacki/services/controllers/create_post_controller.dart';
import 'package:macanacki/services/middleware/create_post_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../services/middleware/button_ware.dart';
import '../../../../operations.dart';
import 'add_button_individual.dart';

class CreatePostScreen extends StatefulWidget {
  final String? initialCaption;
  const CreatePostScreen({super.key, this.initialCaption = ''});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController caption = TextEditingController();
  TextEditingController buttonController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Operations.controlSystemColor();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      caption.text = widget.initialCaption ?? '';
      await ButtonController.retrievButtonsController(context);
    });
  }

  Future<Uint8List?> getThumbnail(File media) async {
    final fileName = await VideoThumbnail.thumbnailData(
      video: media.path,
      // thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    ).whenComplete(() => log(" thumbnail generated"));

    String t = fileName.toString();
    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    CreatePostWare post = Provider.of<CreatePostWare>(context, listen: false);

    CreatePostWare stream = context.watch<CreatePostWare>();
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          color: backgroundSecondary,
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  height: height * 0.06,
                  width: width,
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
                        mainAxisAlignment: MainAxisAlignment.end,
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
                          stream.loadStatus
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
                          // stream.loadStatus
                          //     ? Loader(color: textPrimary)
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 17, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Avatar(
                                    image: user.userProfileModel.profilephoto ??
                                        "",
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
                                    if (user.userProfileModel.gender ==
                                        "Business") {
                                      buttonModal(context, buttonController);
                                    } else {
                                      buttonIndividualModal(
                                          context, buttonController);
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: HexColor(backgroundColor),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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

                      Padding(
                        padding: EdgeInsets.all(0),
                        child: CaptionForm(
                          caption: caption,
                          enabled: stream.loadStatus ? false : true,
                        ),
                      ),
                      post.file!.length > 1
                          ? Container(
                              height: 80,
                              //  color: Colors.amber,
                              width: double.infinity,
                              child: ListView.builder(
                                  itemCount: post.file!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    File image = post.file![index];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          image.path.contains(".mp4")
                                              ? FutureBuilder<Uint8List?>(
                                                  future: getThumbnail(image),
                                                  builder: (context,
                                                      AsyncSnapshot<Uint8List?>
                                                          snapshot) {
                                                    Uint8List? path;
                                                    if (!snapshot.hasData) {
                                                    } else {
                                                      path = snapshot.data!;
                                                    }
                                                    return Container(
                                                      width: 100,
                                                      height: 100,
                                                      // decoration: BoxDecoration(
                                                      //     image: DecorationImage(
                                                      //         fit: BoxFit.cover,
                                                      //         image: FileImage(
                                                      //             File(path)))

                                                      //),

                                                      child: path == null
                                                          ? Loader(
                                                              color:
                                                                  textPrimary)
                                                          : Image.memory(
                                                              path,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    );
                                                  })
                                              : Container(
                                                  width: 100,
                                                  height: 100,
                                                  child: Image.file(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () => stream.loadStatus
                                                  ? null
                                                  : post.removeFile(index),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color:
                                                            HexColor("#FFFFFF"),
                                                        style:
                                                            BorderStyle.none)),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))
                          : const SizedBox.shrink(),
                      SizedBox(
                        height: 20,
                      ),
                      post.file!.first.path.contains('.mp4')
                          ? VideoHolder(file: post.file!.first)
                          : Container(
                              width: Get.width,
                              height: 230,
                              // color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Image.file(
                                  post.file!.first,
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      // Stack(
                      //   alignment: Alignment.center,
                      //   children: [
                      //     // post.file!.first.path.contains('.mp4')
                      //     //     ? VideoHolder(file: post.file!.first)
                      //     //     : Center(
                      //     //         child: Padding(
                      //     //       padding: const EdgeInsets.only(bottom: 0),
                      //     //       child: Image.file(post.file!.first),
                      //     //     )),
                      //     // stream.loadStatus
                      //     //     ? const SizedBox.shrink()
                      //     //     : Column(
                      //     //         mainAxisAlignment: MainAxisAlignment.center,
                      //     //         children: [
                      //     //           // post.file!.length > 1
                      //     //           //     ? Container(
                      //     //           //         height: 80,
                      //     //           //         //  color: Colors.amber,
                      //     //           //         width: double.infinity,
                      //     //           //         child: ListView.builder(
                      //     //           //             itemCount: post.file!.length,
                      //     //           //             scrollDirection: Axis.horizontal,
                      //     //           //             itemBuilder: (context, index) {
                      //     //           //               File image = post.file![index];

                      //     //           //               return Stack(
                      //     //           //                 children: [
                      //     //           //                   image.path.contains(".mp4")
                      //     //           //                       ? FutureBuilder<
                      //     //           //                               Uint8List?>(
                      //     //           //                           future:
                      //     //           //                               getThumbnail(
                      //     //           //                                   image),
                      //     //           //                           builder: (context,
                      //     //           //                               AsyncSnapshot<
                      //     //           //                                       Uint8List?>
                      //     //           //                                   snapshot) {
                      //     //           //                             Uint8List? path;
                      //     //           //                             if (!snapshot
                      //     //           //                                 .hasData) {
                      //     //           //                             } else {
                      //     //           //                               path = snapshot
                      //     //           //                                   .data!;
                      //     //           //                             }
                      //     //           //                             return Container(
                      //     //           //                               width: 100,
                      //     //           //                               height: 100,
                      //     //           //                               // decoration: BoxDecoration(
                      //     //           //                               //     image: DecorationImage(
                      //     //           //                               //         fit: BoxFit.cover,
                      //     //           //                               //         image: FileImage(
                      //     //           //                               //             File(path)))

                      //     //           //                               //),

                      //     //           //                               child: path ==
                      //     //           //                                       null
                      //     //           //                                   ? Loader(
                      //     //           //                                       color: HexColor(
                      //     //           //                                           primaryColor))
                      //     //           //                                   : Image
                      //     //           //                                       .memory(
                      //     //           //                                       path,
                      //     //           //                                       fit: BoxFit
                      //     //           //                                           .cover,
                      //     //           //                                     ),
                      //     //           //                             );
                      //     //           //                           })
                      //     //           //                       : Container(
                      //     //           //                           width: 100,
                      //     //           //                           height: 100,
                      //     //           //                           child: Image.file(
                      //     //           //                             image,
                      //     //           //                             fit: BoxFit.cover,
                      //     //           //                           ),
                      //     //           //                         ),
                      //     //           //                   Positioned(
                      //     //           //                     right: 0.1,
                      //     //           //                     child: InkWell(
                      //     //           //                       onTap: () => post
                      //     //           //                           .removeFile(index),
                      //     //           //                       child: Container(
                      //     //           //                         decoration: BoxDecoration(
                      //     //           //                             shape: BoxShape
                      //     //           //                                 .circle,
                      //     //           //                             border: Border.all(
                      //     //           //                                 width: 1.0,
                      //     //           //                                 color: HexColor(
                      //     //           //                                     "#FFFFFF"),
                      //     //           //                                 style: BorderStyle
                      //     //           //                                     .solid)),
                      //     //           //                         child: Icon(
                      //     //           //                           Icons.clear,
                      //     //           //                           color: HexColor(
                      //     //           //                               "#FFFFFF"),
                      //     //           //                         ),
                      //     //           //                       ),
                      //     //           //                     ),
                      //     //           //                   ),
                      //     //           //                 ],
                      //     //           //               );
                      //     //           //             }))
                      //     //           //     : const SizedBox.shrink(),
                      //     //           // CaptionForm(
                      //     //           //   caption: caption,
                      //     //           // ),
                      //     //         ],
                      //     //       )

                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    if (user.userProfileModel.gender == "Business") {
      if (button.url.isNotEmpty) {
        if (button.url.contains("https://") || button.name == "Call Now") {
          await CreatePostController.createPostController(
              context, caption.text);
        } else {
          showToast2(context, "Url must contain https://", isError: true);
        }
      } else {
        await CreatePostController.createPostController(context, caption.text);
      }
    } else {
      // button.addIndex(0);
      // button.addUrl("");
      await CreatePostController.createPostController(context, caption.text);
    }
  }
}
