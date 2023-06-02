import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/add_button.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/caption_form.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/video_holder.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/button_controller.dart';
import 'package:makanaki/services/controllers/create_post_controller.dart';
import 'package:makanaki/services/middleware/create_post_ware.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../../../../services/middleware/button_ware.dart';

class EditPostScreen extends StatefulWidget {
  final String media;
  final int id;
  const EditPostScreen({super.key, required this.media, required this.id});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController caption = TextEditingController();
  TextEditingController buttonController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ButtonController.retrievButtonsController(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    CreatePostWare post = Provider.of<CreatePostWare>(context, listen: false);

    CreatePostWare stream = context.watch<CreatePostWare>();
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
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
                    InkWell(
                      onTap: () => PageRouting.popToPage(context),
                      child: Container(
                        height: 26.67,
                        width: 26.67,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: HexColor("#C0C0C0"),
                                style: BorderStyle.solid)),
                        child: Icon(
                          Icons.clear,
                          size: 18,
                          color: HexColor("#C0C0C0"),
                        ),
                      ),
                    ),
                    AppText(
                      text: "Edit Post",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      size: 17,
                    ),
                    Row(
                      children: [
                        stream.loadEditPost
                            ? Loader(color: HexColor(primaryColor))
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: HexColor(primaryColor),
                                    fixedSize: Size(85, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    side: BorderSide(
                                        color: HexColor(primaryColor),
                                        width: 1.0,
                                        style: BorderStyle.solid)),
                                onPressed: () => _submit(context),
                                child: AppText(
                                  text: "Update",
                                  size: 10,
                                  color: HexColor(backgroundColor),
                                  fontWeight: FontWeight.w700,
                                ))
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  widget.media.contains('.mp4')
                      ? VideoHolderTwo(file: widget.media)
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Image.network(widget.media),
                        )),
                  stream.loadStatus
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CaptionForm(
                              caption: caption,
                            ),
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    ButtonWare button = Provider.of<ButtonWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    if (caption.text.isEmpty) {
      showToast2(context, "Kindly add caption", isError: true);
      return;
    }
    print(widget.id);

    await CreatePostController.editPost(context, widget.id, caption.text);
  }
}
