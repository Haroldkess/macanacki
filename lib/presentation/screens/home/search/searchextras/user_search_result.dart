import 'package:flutter/material.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/search/searchextras/nothing_found.dart';
import 'package:macanacki/presentation/screens/home/search/searchextras/search_loader.dart';
import 'package:macanacki/presentation/screens/home/search/searchextras/user_result_tile.dart';
import 'package:macanacki/services/middleware/search_ware.dart';
import 'package:provider/provider.dart';

import '../../../../../model/search_user_model.dart';

class UserGlobalResult extends StatelessWidget {
  final String userName;
  const UserGlobalResult({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    SearchWare stream = context.watch<SearchWare>();

    return stream.loadStatus == false && stream.userFound.isEmpty
        ? const NoSearchFound()
        : ListView.builder(
            itemCount: stream.userFound.length,
            padding: EdgeInsets.only(top: 5),
            itemBuilder: (context, index) {
              UserSearchData searchData = stream.userFound[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: stream.loadStatus
                    ? const SearchLoader()
                    : UserResultTile(data: searchData, username: userName),
              );
            },
          );
  }
}
