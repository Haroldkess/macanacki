import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/follow_tile.dart';
import 'package:provider/provider.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

import '../../../../../model/following_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../uiproviders/screen/find_people_provider.dart';
import '../../../../widgets/loader.dart';
import '../../../../widgets/text.dart';

class FollowFollowingList extends StatefulWidget {
  String what;
  final ActionWare ware;
  FollowFollowingList({
    super.key,
    required this.what,
    required this.ware,
  });

  @override
  State<FollowFollowingList> createState() => _FollowFollowingListState();
}

class _FollowFollowingListState extends State<FollowFollowingList> {
  final _controller = ScrollController();

  Future<void> fetchPage() async {
    if (widget.what == 'Following') {
      print(
          "*****************Getting following data  From [Follow_list Widget] ");

      widget.ware.getFollowingFromApi();
    } else {
      widget.ware.getFollowersFromApi();
      print(
          "*****************Getting followers data From [Follow_list Widget]");
    }
  }

  void clearGlobalSearch() {
    ActionWare search = Provider.of<ActionWare>(context, listen: false);
    search.updateSearch("");
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      //Clear All Search Value
      clearGlobalSearch();

      //
      widget.ware.initializePagingController();

      // Add new page
      widget.ware.pagingController.addPageRequestListener((pageKey) {
        // Add scrollController listener
        _controller.addListener(() {
          if (_controller.position.atEdge) {
            bool isTop = _controller.position.pixels == 0;
            if (isTop) {
              print('At the top');
            } else {
              print('At the bottom');
              //
              EasyDebounce.debounce('my-debouncer', const Duration(seconds: 1),
                  () async => await fetchPage());
              // print(pageKey);
              // print("Inside page key");
            }
          }
        });
      });
      fetchPage();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.ware.disposeAutoScroll());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();

    return Stack(
      children: [
        PagedListView<int, FollowingData>(
          pagingController: stream.pagingController,
          builderDelegate: PagedChildBuilderDelegate<FollowingData>(
            itemBuilder: (context, item, index) {
              FollowingData followerData = item;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: FollowTile(
                  data: followerData,
                ),
              );
            },
            newPageProgressIndicatorBuilder: (context) {
              return Loader(color: HexColor(primaryColor));
            },
            firstPageProgressIndicatorBuilder: (context) {
              return Loader(color: HexColor(primaryColor));
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icon/crown.svg",
                      height: 30,
                      width: 30,
                      color: HexColor(primaryColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                      text: "Oops you have no ${widget.what}",
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
              );
<<<<<<< HEAD
            });
  
  
=======
            },
          ),
          scrollController: _controller,
        ),

        // ListView.builder(
        //   controller: stream.scrollController,
        //   physics: const ScrollPhysics(),
        //   itemCount: searched.length,
        //   itemBuilder: (context, index) {
        //     FollowingData followerData = searched[index];
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(
        //           vertical: 10, horizontal: 10),
        //       child: FollowTile(
        //         data: followerData,
        //       ),
        //     );
        //     // return GestureDetector(
        //     //   onTap: () {
        //     //     stream.scrollDown();
        //     //   },
        //     //   child: Container(
        //     //     height: 100,
        //     //     width: double.infinity,
        //     //     color: Colors.grey,
        //     //     child: Text(
        //     //       "${index.toString()}",
        //     //       style: TextStyle(color: Colors.white),
        //     //     ),
        //     //     margin: EdgeInsets.all(20),
        //     //     padding: EdgeInsets.symmetric(
        //     //         vertical: 20, horizontal: 20),
        //     //   ),
        //     // );
        //   },
        // ),
      ],
    );
>>>>>>> e2b637bd7988201eca5fd12bddf9e3b43d87b91d
  }
}
