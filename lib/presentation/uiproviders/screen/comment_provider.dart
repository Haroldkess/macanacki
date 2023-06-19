import 'package:flutter/cupertino.dart';

import '../../../model/feed_post_model.dart';

class StoreComment extends ChangeNotifier {
  List<dynamic> _comments = [];
  List<dynamic> _feedcomments = [];
  List<dynamic> get comments => _comments;
   List<dynamic> get feedcomments => _feedcomments;

  Future<void> addAllComments(List comment) async {
    _comments = comment;
    notifyListeners();
  }

  Future<void> addSingleComment(Comment comment) async {
    _comments.add(comment);
    notifyListeners();
  }

  Future<void> removeSingleComment(postId, commentId) async {
    _comments.removeWhere(
        (element) => element.id == commentId && element.postId == postId);
          notifyListeners();
  }
}
