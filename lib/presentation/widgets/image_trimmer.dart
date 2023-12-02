import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:native_image_cropper/native_image_cropper.dart';

import '../constants/colors.dart';


class ImageTrimmer extends StatefulWidget {
  final Uint8List bytes;
  final Function(Uint8List?) onCrop;
  const ImageTrimmer({Key? key, required this.bytes, required this.onCrop }) : super(key: key);

  @override
  State<ImageTrimmer> createState() => _ImageTrimmerState();



}

class _ImageTrimmerState extends State<ImageTrimmer> {

  late CropController controller;

  @override
  void initState() {
    super.initState();
    controller = CropController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(darkColor),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor(primaryColor),
        child: Icon(Icons.crop_outlined),
        onPressed: () async {
          final croppedBytes =  await controller.crop();
          print(croppedBytes.toString());
          widget.onCrop(croppedBytes);
        },
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor(darkColor),
      ),
      body: CropPreview(
          mode: CropMode.rect,
          dragPointSize: 20,
          hitSize: 20,
          bytes: widget.bytes,
      maskOptions: const MaskOptions(
        backgroundColor: Colors.black38,
        borderColor: Colors.grey,
        strokeWidth: 2,
        aspectRatio: 4 / 3,
        minSize: 0,
      ),
      dragPointBuilder: (size, position) {
        if (position == CropDragPointPosition.topLeft) {
          return CropDragPoint(size: size, color: Colors.red);
        }
        return CropDragPoint(size: size, color: Colors.blue);
      },
    ),
    );
  }
}
