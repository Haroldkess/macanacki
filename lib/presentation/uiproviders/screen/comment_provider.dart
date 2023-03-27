import 'package:flutter/cupertino.dart';

import '../../../model/feed_post_model.dart';


class StoreComment extends ChangeNotifier {
  List<dynamic> _comments = [];
  List<dynamic> get comments => _comments;

  Future<void> addAllComments(List comment) async {
    _comments = comment;
    notifyListeners();
  }

  
  Future<void> addSingleComment(Comment comment) async {
    _comments.add(comment);
    notifyListeners();
  }
}
