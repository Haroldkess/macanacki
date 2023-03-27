import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/caption_form.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/video_holder.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/create_post_controller.dart';
import 'package:makanaki/services/middleware/create_post_ware.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController caption = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    CreatePostWare post = Provider.of<CreatePostWare>(context, listen: false);

    CreatePostWare stream = context.watch<CreatePostWare>();

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
                      text: "New Post",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      size: 17,
                    ),
                    stream.loadStatus
                        ? Loader(color: HexColor(primaryColor))
                        : OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: HexColor(primaryColor),
                                fixedSize: Size(72, 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                    color: HexColor(primaryColor),
                                    width: 1.0,
                                    style: BorderStyle.solid)),
                            onPressed: () => _submit(context),
                            child: AppText(
                              text: "Post",
                              scaleFactor: 0.8,
                              color: HexColor(backgroundColor),
                              fontWeight: FontWeight.w500,
                            ))
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  post.file!.path.contains('.mp4')
                      ? VideoHolder(file: post.file!)
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Image.file(post.file!),
                        )),
                  stream.loadStatus
                      ? const SizedBox.shrink()
                      : CaptionForm(
                          caption: caption,
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
    if (caption.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please add caption",
          backgroundColor: Colors.red.shade300,
          gravity: ToastGravity.TOP);
      return;
    } else {
      await CreatePostController.createPostController(context, caption.text);
    }
  }
}
