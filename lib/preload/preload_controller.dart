import 'package:get/get.dart';
import 'package:macanacki/preload/preload_model.dart';
import 'package:macanacki/preload/preload_state.dart';
import 'package:video_player/video_player.dart';

class PreloadController extends GetxController{
  PreloadController();

  static PreloadController get to => Get.find();

  final state = PreloadState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  
  


  Future<void> addPreload({ required int id, required List<dynamic> vod}) async {

    if(vod.first == null) return;
    if(vod.isEmpty) return ;
    if(vod.first.toString().contains('.mp4') == false) return;

    print("------------------ Add Preload ------ ${vod} ");

    if(state.preloads.where((x) => x.id == id).isEmpty) {
      final controller =
      VideoPlayerController.networkUrl(Uri.parse(vod!.first));
      await Future.wait([ controller.initialize()]);
      state.preloads.add(
          PreloadModel(id: id, vod: vod, controller: controller));
    }
  }

  void addPreloads(List<PreloadModel> values){
    clear();
    state.preloads.addAll(values);
  }
  
  PreloadModel getPreloadById(int id){
    print("--------------------------------------Getting Data from Preload");
    return state.preloads.where((x) => x.id == id).first;
  }

  void removePreloadById(int id){
    print("--------------------------------------Removing Data from Preload");
    state.preloads.where((x) => x.id == id).first.controller?.dispose();
    state.preloads.removeWhere((x) => x.id == id );
  }

  void pausePreloadById(int id){
    print("--------------------------------------Pause Preload by ID");
    state.preloads.where((x) => x.id == id).first.controller?.pause();
  }

  void clear(){
    print("-------------------------------------- Clearing Datas from Preload");
    for (var element in state.preloads) {
      element.controller?.dispose();
    }
    state.preloads.clear();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    clear();
    super.dispose();
  }
  
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}