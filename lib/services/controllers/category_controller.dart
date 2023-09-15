import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/category_ware.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/widgets/debug_emitter.dart';

class CategoryController {
  static Future<void> retrievCategoryController(BuildContext context) async {
    CategoryWare ware = Provider.of<CategoryWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware.getCatFromApi().whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "An error occured", isError: true);
    }
      ware.isLoading(false);
  }
}
