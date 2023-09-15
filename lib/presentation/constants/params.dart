const buttonCurves = 5.0;
const horizontalPadding = 40.0;
String url =
    "https://media.istockphoto.com/id/1293448341/photo/girl-is-relaxing-during-spa-day.jpg?s=612x612&w=0&k=20&c=-5Tbh41r26LLqWQrwpeXi6Klrp1MGgUUNFVFJgmxFZM=";

const accessTokenMUX = "0a2634e4-5cbc-48dd-9527-b27afaa02801";

const secretTokenMUX =
    "iFS8dZrSS6OTWRq+2kCuimYNsoEhkdLAi9f1T08J90k9zXBvCv6ZJUuIBznrV2KH1HNgZXy871B";

const sub = "inactive subscription";


convertToCurrency(String e) {
  String newStr = e.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[0]},");
  return newStr;
}
