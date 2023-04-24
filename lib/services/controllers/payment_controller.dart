import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/subscription/sub_successful.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

String sk = dotenv.get('SECRET_KEY').toString();
final plugin = PaystackPlugin();

class PaymentController {
  static PaymentCard getCardFromUI() {
    // Using just the must-required parameters.
    //4084084084084081
    return PaymentCard(
      number: "",
      cvc: "408",
      expiryMonth: 4,
      expiryYear: 24,
    );
  }

  static Future chargeCard(BuildContext context, int amount) async {
    log(sk);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    final String ref = await getReference();
    // ignore: use_build_context_synchronously
    String access = await createAccessCode(ref, context, amount.toString());
    Charge charge = Charge();

    PaymentCard myCard = getCardFromUI();

    charge
      ..amount = amount // In base currency
      ..email = user.userProfileModel.email
      ..reference = ref
      ..accessCode = access
      ..putCustomField('Charged From', 'Flutter SDK')
      ..card = myCard.number!.isEmpty ? null : myCard;

    try {
      // ignore: use_build_context_synchronously
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.selectable,
        charge: charge,
        fullscreen: true,
        logo: SvgPicture.asset(
          "assets/icon/crown.svg",
          color: HexColor(primaryColor),
        ),
      );

      if (response.status == true) {
        // ignore: use_build_context_synchronously
        verifyOnServer(response.reference!, context);
      } else {
        print('Response = $response');
        //  showToast2(context, message)
      }
    } catch (e) {
      print("Check console for error");
      return;
      //'rethrow;
    }

    //  final response = await plugin.chargeCard(context, charge: charge);
    // Use the response
  }

  static Future<String> createAccessCode(
      reference, context, String amount) async {
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $sk'
    };
    Map data = {
      "amount": amount,
      "email": "${user.userProfileModel.email}",
      "reference": reference
    };
    String payload = json.encode(data);
    http.Response response = await http
        .post(Uri.parse('https://api.paystack.co/transaction/initialize'),
            headers: headers, body: payload)
        .timeout(const Duration(seconds: 30));
    var data2 = jsonDecode(response.body);
    // print(data2.toString());
    String accessCode = data2['data']['access_code'];
    return accessCode;
  }

  static void verifyOnServer(String reference, context) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $sk'
      };
      http.Response response = await http
          .get(
              Uri.parse(
                  'https://api.paystack.co/transaction/verify/$reference'),
              headers: headers)
          .timeout(const Duration(seconds: 30));
      final Map body = json.decode(response.body);
      if (body['data']['status'] == 'success') {
        // log("paid");
        PageRouting.popToPage(context);
        PageRouting.pushToPage(context, const SubSuccessfull());
        //do something with the response. show success}
        //show error prompt}
        return;
      } else {
        showToast2(context, "Payment not verified try again", isError: true);
        return;
      }
    } catch (e) {
      // print(e);
      return;
    }
  }

  static Future<String> getReference() async {
    late String ret;
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    ret =
        'ChargedFrom${platform}Makanaki${DateTime.now().millisecondsSinceEpoch.toString()}';

    return ret;
  }
}
