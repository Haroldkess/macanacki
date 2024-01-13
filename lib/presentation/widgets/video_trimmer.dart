import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/middleware/video_trimmer_ware.dart';
import 'package:provider/provider.dart';
import 'package:video_trimmer/video_trimmer.dart';
import '../../services/middleware/create_post_ware.dart';
import '../allNavigation.dart';
import '../constants/params.dart';
import 'dart:io';
import 'loader.dart';

class VideoTrimmer extends StatefulWidget {
  final File file;
  const VideoTrimmer({Key? key, required this.file}) : super(key: key);

  @override
  _VideoTrimmerState createState() => _VideoTrimmerState();
}

class _VideoTrimmerState extends State<VideoTrimmer> {
  final TextEditingController _textEditingController = TextEditingController();
  final Trimmer _trimmer = Trimmer();

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _loadVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    CreatePostWare stream = context.watch<CreatePostWare>();
    VideoTrimmerWare ware = context.watch<VideoTrimmerWare>();
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: HexColor(darkColor),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              _buildAppBarField(context, ware),
              buildVideoPreviewField(context, ware),
              _buildTrimmerAndFormField(context, stream, ware)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrimmerAndFormField(
      BuildContext context, CreatePostWare stream, VideoTrimmerWare ware) {
    return Column(
      children: [
        //Trimmer
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: HexColor('#F5F5F5').withOpacity(0.07),
          width: double.infinity,
          child: TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 50.0,
              showDuration: true,
              durationStyle: DurationStyle.FORMAT_MM_SS,
              type: ViewerType.auto,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: const Duration(seconds: 30),
              onChangeStart: (value) => ware.updateStartValue(value),
              onChangeEnd: (value) => ware.updateEndValue(value),
              onChangePlaybackState: (value) => ware.updateIsPlaying(value)),
        ),
        const SizedBox(height: 0),

        //Form Field
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor('#F5F5F5').withOpacity(0.07),
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                child: TextFormField(
                  controller: _textEditingController,
                  cursorColor: HexColor(primaryColor),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  minLines: 1, //Normal textInputField will be displayed
                  maxLines: 5, // when user presses enter it will adapt to it
                  style: TextStyle(color: HexColor("#C0C0C0")),
                  onChanged: (value) async {
                    ware.updateCaption(value);
                  },
                  decoration: InputDecoration(
                    hintText: " Caption",
                    hintStyle: GoogleFonts.leagueSpartan(
                        color: HexColor("#C0C0C0"), fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(color: HexColor("#F5F2F9"))),
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(color: textPrimary)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ware.progressVisibility == true
                  ? const Loader(color: Colors.white)
                  : AppButton(
                      width: 0.2,
                      height: 0.06,
                      color: "#ffffff",
                      text: "Done",
                      backColor: "#ffffff",
                      curves: buttonCurves,
                      textColor: backgroundColor,
                      onTap: () async {
                        ware.updateProgressVisibility(true);

                        try {
                          emitter("Begin Video Triming **");
                          await _trimmer.saveTrimmedVideo(
                              startValue: ware.startValue,
                              endValue: ware.endValue,
                              onSave: (String? outputPath) async {
                                emitter(
                                    "Trimming completed ${outputPath.toString()}");
                                emitter(ware
                                    .getFileSize(File(outputPath!))
                                    .toString());
                                stream.addFile([File(outputPath.toString())]);

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  PageRouting.pushToPage(
                                      context,
                                      CreatePostScreen(
                                        initialCaption: ware.caption ?? '',
                                      ));
                                }
                              });
                        } catch (e) {
                          emitter("Something went wrong ");
                        } finally {
                          setState(() {
                            ware.updateProgressVisibility(false);
                          });
                        }
                      },
                    ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildVideoPreviewField(BuildContext context, VideoTrimmerWare ware) {
    return Expanded(
        child: Stack(
      children: [
        VideoViewer(trimmer: _trimmer),
        Align(
          alignment: Alignment.center,
          child: Align(
            alignment: Alignment.center,
            child: TextButton(
              child: ware.isPlaying
                  ? const Icon(
                      Icons.pause_circle_outline,
                      size: 60.0,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.play_circle_fill_outlined,
                      size: 60.0,
                      color: Colors.white,
                    ),
              onPressed: () async {
                bool playbackState = await _trimmer.videoPlaybackControl(
                  startValue: ware.startValue,
                  endValue: ware.endValue,
                );
                ware.updateIsPlaying(playbackState);
              },
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildAppBarField(BuildContext context, VideoTrimmerWare ware) {
    return Column(
      children: [
        Visibility(
            visible: ware.progressVisibility == false,
            child: Container(
              width: double.infinity,
              height: 7,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.red,
              ),
            )),
        Visibility(
          visible: ware.progressVisibility,
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: HexColor(primaryColor),
            minHeight: 7,
            //  borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(11.0),
                decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5).withOpacity(0.07),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5).withOpacity(0.07),
                  shape: BoxShape.circle),
              child: Text('30',
                  style: GoogleFonts.leagueSpartan(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decorationStyle: TextDecorationStyle.solid,
                    fontSize: 15,
                    fontFamily: '',
                  ))),
            ),
          ],
        )
      ],
    );
  }
}
