const buttonCurves = 5.0;
const horizontalPadding = 40.0;
String url =
    "https://e7.pngegg.com/pngimages/487/216/png-clipart-iphone-7-push-technology-apple-push-notification-service-computer-icons-instant-hat-logo.png";

const accessTokenMUX = "0a2634e4-5cbc-48dd-9527-b27afaa02801";

const secretTokenMUX =
    "iFS8dZrSS6OTWRq+2kCuimYNsoEhkdLAi9f1T08J90k9zXBvCv6ZJUuIBznrV2KH1HNgZXy871B";

const sub = "inactive subscription";


convertToCurrency(String e) {
  String newStr = e.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[0]},");
  return newStr;
}
