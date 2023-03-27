import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus {
  like,
  disLike,
  superLike,
}

class CardProvider extends ChangeNotifier {
  List<String> _urlImages = <String>[
      "https://images.pexels.com/photos/3992656/pexels-photo-3992656.png?cs=srgb&dl=pexels-kebs-visuals-3992656.jpg&fm=jpg"
          "https://img.freepik.com/free-photo/portrait-dark-skinned-cheerful-woman-with-curly-hair-touches-chin-gently-laughs-happily-enjoys-day-off-feels-happy-enthusiastic-hears-something-positive-wears-casual-blue-turtleneck_273609-43443.jpg?w=2000",
      "https://media.istockphoto.com/id/1369508766/photo/beautiful-successful-latin-woman-smiling.jpg?b=1&s=170667a&w=0&k=20&c=owOOPDbI6VOp1xYA4smdTNSHxjcJGRtGfVXx24g6J4c=",
      "https://img.freepik.com/free-photo/happiness-wellbeing-confidence-concept-cheerful-attractive-african-american-woman-curly-haircut-cross-arms-chest-self-assured-powerful-pose-smiling-determined-wear-yellow-sweater_176420-35063.jpg?w=2000",
      "https://images.unsplash.com/photo-1599842057874-37393e9342df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjh8fGdpcmx8ZW58MHx8MHx8&w=1000&q=80",
      "https://guardian.ng/wp-content/uploads/2016/12/adi.jpg",
      "https://media.istockphoto.com/id/1347431090/photo/fit-woman-standing-outdoors-after-a-late-afternoon-trail-run.jpg?b=1&s=170667a&w=0&k=20&c=6g2hGmKckPzapXNLHWGRMCpPMJidJVsutxU-XrsIjBU="
    ].reversed.toList();
  bool _isDragging = false;
  Offset _position = Offset.zero;
  double _angle = 0;
  Size _screenSize = Size.zero;
  Offset get position => _position;

  bool get isDragging => _isDragging;

  double get angle => _angle;
  List<String> get urlImages => _urlImages;

  // CardProvider() {
  //   resetUsers();
  // }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus();

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: status.toString().split('.').last.toUpperCase(), fontSize: 36);
    }

    switch (status) {
      case CardStatus.like:
        like();

        break;
      case CardStatus.disLike:
        disLike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        resetPosition();
    }

    notifyListeners();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  CardStatus? getStatus() {
    late CardStatus card;
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    const delta = 100;

    if (x >= delta) {
      card = CardStatus.like;
    } else if (x <= delta) {
      card = CardStatus.disLike;
    } else if (y <= -delta / 2 && forceSuperLike) {
      card = CardStatus.superLike;
    }
    notifyListeners();
    return card;
  }

  void disLike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(const Duration(milliseconds: 200));

    _urlImages.removeLast;
    notifyListeners();

    resetPosition();
  }

  void resetUsers() {
    _urlImages = <String>[
      "https://images.pexels.com/photos/3992656/pexels-photo-3992656.png?cs=srgb&dl=pexels-kebs-visuals-3992656.jpg&fm=jpg"
          "https://img.freepik.com/free-photo/portrait-dark-skinned-cheerful-woman-with-curly-hair-touches-chin-gently-laughs-happily-enjoys-day-off-feels-happy-enthusiastic-hears-something-positive-wears-casual-blue-turtleneck_273609-43443.jpg?w=2000",
      "https://media.istockphoto.com/id/1369508766/photo/beautiful-successful-latin-woman-smiling.jpg?b=1&s=170667a&w=0&k=20&c=owOOPDbI6VOp1xYA4smdTNSHxjcJGRtGfVXx24g6J4c=",
      "https://img.freepik.com/free-photo/happiness-wellbeing-confidence-concept-cheerful-attractive-african-american-woman-curly-haircut-cross-arms-chest-self-assured-powerful-pose-smiling-determined-wear-yellow-sweater_176420-35063.jpg?w=2000",
      "https://images.unsplash.com/photo-1599842057874-37393e9342df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjh8fGdpcmx8ZW58MHx8MHx8&w=1000&q=80",
      "https://guardian.ng/wp-content/uploads/2016/12/adi.jpg",
      "https://media.istockphoto.com/id/1347431090/photo/fit-woman-standing-outdoors-after-a-late-afternoon-trail-run.jpg?b=1&s=170667a&w=0&k=20&c=6g2hGmKckPzapXNLHWGRMCpPMJidJVsutxU-XrsIjBU="
    ].reversed.toList();
    notifyListeners();
  }
}
