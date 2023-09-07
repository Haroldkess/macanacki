import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/subscription/sub_successful.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/verify_controller.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import '../../presentation/screens/onboarding/business/success.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/dialogue.dart';
 //"sk_test_1a9e1524621e4c91e3489926ef37db7337b4c68f"; 

String sk =
   dotenv.get('SECRET_KEY').toString();

//dotenv.get('SECRET_KEY').toString();
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

  static Future chargeCard(BuildContext context, int amount,
      [bool? isFirst, isPayOnly, String? id]) async {
    //  log(sk);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    final String ref = await getReference();
    // ignore: use_build_context_synchronously
    String access =
        // ignore: use_build_context_synchronously
        await createAccessCode(ref, context, amount.toString(), id);
    Charge charge = Charge();

    PaymentCard myCard = getCardFromUI();
    emitter("access code " + access + "  ref  " + ref);

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
        //    emitter("you clicked on pay");
        // ignore: use_build_context_synchronously
        verifyOnServer(response.reference!, context, isFirst, isPayOnly);
      } else {
        emitter('Response = $response');
        //  showToast2(context, message)
      }
    } catch (e) {
      emitter("Check console for error $e");
      return;
      //'rethrow;
    }

    //  final response = await plugin.chargeCard(context, charge: charge);
    // Use the response
  }

  static Future<String> createAccessCode(reference, context, String amount,
      [String? id]) async {
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
      "reference": reference,
    };

    Map promoteData = {
      "amount": amount,
      "email": "${user.userProfileModel.email}",
      "reference": reference,
      "metadata": {"post_id": id}
    };
    String payload = id == null ? json.encode(data) : json.encode(promoteData);
    http.Response response = await http
        .post(Uri.parse('https://api.paystack.co/transaction/initialize'),
            headers: headers, body: payload)
        .timeout(const Duration(seconds: 30));
    var data2 = jsonDecode(response.body);
    // print(data2.toString());
    String accessCode = data2['data']['access_code'];
    return accessCode;
  }

  static void verifyOnServer(
      String reference, context, bool? isFirst, bool isPayOnly) async {
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

        if (isFirst != null) {
          if (isFirst == true) {
            if (isPayOnly == false) {
              VerifyController.business(context);
            }

            //  PageRouting.popToPage(context);
            PageRouting.pushToPage(
                context, const SubSuccessfullBusinessSignUp());
          } else {
            if (isPayOnly == false) {
              VerifyController.userVerify(context);
            }

            PageRouting.pushToPage(context, const SubSuccessfull());
          }
        } else {
          //  Get.off(2);
          Get.back();
          Get.back();
          Get.dialog(
            confirmationDialog(
                title: "Promotion Successful",
                message: "You just promoted a post",
                confirmText: "Okay",
                cancelText: "Go back",
                icon: Icons.donut_small_outlined,
                iconColor: [HexColor(primaryColor), Colors.green],
                onPressedCancel: () {
                  Get.back();
                },
                onPressed: () {
                  Get.back();
                }),
          );
          emitter("tidy");
        }

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
        'ChargedFrom${platform}macanacki${DateTime.now().millisecondsSinceEpoch.toString()}';

    return ret;
  }
}
