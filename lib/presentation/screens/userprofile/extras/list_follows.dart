import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/model/public_profile_model.dart';
import 'package:macanacki/model/public_user_follower_and_following_model.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/follow_tile.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/public_tile.dart';
import 'package:macanacki/services/middleware/user_profile_ext_ware.dart';
import 'package:provider/provider.dart';

import '../../../../../model/following_model.dart';
import '../../../constants/colors.dart';
import '../../../uiproviders/screen/find_people_provider.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/text.dart';

class PublicFollowFollowingList extends StatefulWidget {
  List<PublicUserData> data;
  String what;
  final UserProfileExtWare ware;
  PublicFollowFollowingList(
      {super.key, required this.data, required this.what, required this.ware});

  @override
  State<PublicFollowFollowingList> createState() =>
      _PublicFollowFollowingListState();
}

class _PublicFollowFollowingListState extends State<PublicFollowFollowingList> {
  final _controller = ScrollController();

  Future<void> fetchPage() async {
    if (widget.what == 'Following') {
      widget.ware.getUserPublicFollowingsFromApi();
    } else {
      widget.ware.getUserPublicFollowersFromApi();
    }
  }

  void clearGlobalSearch() {
    UserProfileExtWare search =
        Provider.of<UserProfileExtWare>(context, listen: false);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.ware.disposeAutoScroll();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FindPeopleProvider search = context.watch<FindPeopleProvider>();
    return PagedListView<int, PublicUserFollowerAndFollowingModel>(
      pagingController: widget.ware.pagingController,
      //itemCount: searched.length,

      builderDelegate:
          PagedChildBuilderDelegate<PublicUserFollowerAndFollowingModel>(
        itemBuilder: (context, item, index) {
          PublicUserFollowerAndFollowingModel followerData = item;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: PublicFollowTile(
              data: followerData,
            ),
          );
        },
        newPageProgressIndicatorBuilder: (context) {
          return Loader(color: textWhite);
        },
        firstPageProgressIndicatorBuilder: (context) {
          return Loader(color: textWhite);
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
                  color: Colors.red,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppText(
                  text: "User has no ${widget.what}",
                  color: textPrimary,
                )
              ],
            ),
          );
        },
      ),

      scrollController: _controller,
    );
  }
}
