import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
// import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
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
import 'package:macanacki/services/middleware/gift_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:pay_with_paystack/pay_with_paystack.dart';
// import 'package:paystack_standard/paystack_standard.dart';
import 'package:provider/provider.dart';
import '../../presentation/screens/onboarding/business/success.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/dialogue.dart';
import 'package:get/get.dart';
//"sk_test_1a9e1524621e4c91e3489926ef37db7337b4c68f";

String sk = dotenv.get('SECRET_KEY').toString();
//String sk = "sk_test_1a9e1524621e4c91e3489926ef37db7337b4c68f";
// dotenv.get('SECRET_KEY').toString();

//dotenv.get('SECRET_KEY').toString();
//final plugin = PaystackPayment();

class PaymentController {
  // static PaymentCard getCardFromUI() {
  //   // Using just the must-required parameters.
  //   //4084084084084081
  //   return PaymentCard(
  //     number: "4084084084084081",
  //     cvc: "408",
  //     expiryMonth: 4,
  //     expiryYear: 24,
  //   );
  // }

  static void promote(context) {
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
  }

  static Future<bool> chargeCard(BuildContext context, int amount,
      [bool? isFirst, isPayOnly, String? id]) async {
    //  log(sk);
    late bool success;
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    final String ref = await getReference();
    // ignore: use_build_context_synchronously
    String access = await createAccessCode(ref, context, amount.toString(), id);
    if (access.isNotEmpty) {
//       PaystackStandard(context).checkout(checkoutUrl: access).then((response) {
//         if (response.success) {
//           verifyOnServer(ref, context, isFirst, isPayOnly);
//         } else {}

// // here check for success - verify transaction status with your backend server
//       }).whenComplete(() => verifyOnServer(ref, context, isFirst, isPayOnly));
    }

    // Map data = {
    //   "amount": amount,
    //   "email": "${user.userProfileModel.email}",
    //   "reference": ref,
    // };

    // Map promoteData = {
    //   "amount": amount,
    //   "email": "${user.userProfileModel.email}",
    //   "reference": ref,
    //   "metadata": {"post_id": id}
    // };

    // FlutterPaystackPlus.openPaystackPopup(

//       publicKey: '-Your-public-key-',
//       customerEmail: 'youremail@gmail.com',
//       context:context,
//       secretKey:'-Your-secret-key-',
//       amount: (amount * 100).toString(),

//       reference: DateTime.now().millisecondsSinceEpoch.toString(),
//       onClosed: () {
//         debugPrint('Could\'nt finish payment');
//       },
//       onSuccess: () async {
//         debugPrint('successful payment');
//       },
//     );
    // ignore: use_build_context_synchronously
    // await PayWithPayStack().now(
    //     context: context,
    //     secretKey: sk,
    //     customerEmail: user.userProfileModel.email ?? "",
    //     reference: ref,
    //     callbackUrl: "macanacki.com",
    //     currency: "NGN",
    //     paymentChannel: ["mobile_money", "card"],
    //     amount: "$amount",
    //     metaData: id == null ? data : promoteData,
    //     transactionCompleted: () async {
    //       print("done");
    //       success = true;
    //       // if (isFirst != null) {
    //       //   if (isFirst == true) {
    //       //     if (isPayOnly == false) {
    //       //       VerifyController.business(context);
    //       //     }

    //       //     //  PageRouting.popToPage(context);
    //       //     PageRouting.pushToPage(
    //       //         context, const SubSuccessfullBusinessSignUp());
    //       //   } else {
    //       //     if (isPayOnly == false) {
    //       //       VerifyController.userVerify(context);
    //       //     }

    //       //     PageRouting.pushToPage(context, const SubSuccessfull());
    //       //   }
    //       // } else {
    //       //   //  Get.off(2);
    //       //   promote(context);

    //       //   emitter("tidy");
    //       // }
    //     },
    //     transactionNotCompleted: () {
    //       success = false;
    //       Get.dialog(
    //         confirmationDialog(
    //             title: "Failed",
    //             message: "Payment Failed",
    //             confirmText: "Okay",
    //             cancelText: "Go back",
    //             icon: Icons.error,
    //             iconColor: [HexColor(primaryColor), Colors.red],
    //             onPressedCancel: () {
    //               Get.back();
    //             },
    //             onPressed: () {
    //               Get.back();
    //             }),
    //       );
    //     });

    // Charge charge = Charge();

    // PaymentCard myCard = getCardFromUI();
    // emitter("access code " + access + "  ref  " + ref);

    // charge
    //   ..amount = amount // In base currency
    //   ..email = user.userProfileModel.email
    //   ..reference = ref
    //   ..accessCode = access
    //   ..putCustomField('Charged From', 'Flutter SDK')
    //   ..card = myCard.number!.isEmpty ? null : myCard;

    // try {
    //   // ignore: use_build_context_synchronously
    //   CheckoutResponse response = await plugin.checkout(
    //     context,
    //     method: CheckoutMethod.selectable,
    //     charge: charge,
    //     fullscreen: true,
    //     logo: SvgPicture.asset(
    //       "assets/icon/crown.svg",
    //       color: HexColor(primaryColor),
    //     ),
    //   );

    //   if (response.status == true) {
    //     //    emitter("you clicked on pay");
    //     // ignore: use_build_context_synchronously
    //     verifyOnServer(response.reference!, context, isFirst, isPayOnly);
    //   } else {
    //     emitter('Response = $response');
    //     //  showToast2(context, message)
    //   }
    // } catch (e) {
    //   emitter("Check console for error $e");
    //   return;
    //   //'rethrow;
    // }

    //  final response = await plugin.chargeCard(context, charge: charge);
    // Use the response

    return true;
  }

  static Future<bool> chargeForDiamonds(
    BuildContext context,
    int amount,
  ) async {
    //  log(sk);
    late bool success;
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    final String ref = await getReference();
    // ignore: use_build_context_synchronously
    String access = await createAccessCodeDiamond(
      ref,
      context,
      amount.toString(),
    );
    if (access.isNotEmpty) {
//       PaystackStandard(context).checkout(checkoutUrl: access).then((response) {
//         if (response.success) {
//           verifyOnServerDiamond(
//             ref,
//             context,
//           );
//         } else {}

// // here check for success - verify transaction status with your backend server
//       }).whenComplete(() => verifyOnServerDiamond(
//             ref,
//             context,
//           ));
    
    
    
    }

    return true;
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
      "plan": "PLN_ojmkb58irexmavd",
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
    String authUrl = data2['data']['authorization_url'];
    return authUrl;
  }

  static Future<String> createAccessCodeDiamond(
    reference,
    context,
    String amount,
  ) async {
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
      "metadata": {"wallet_email": "${user.userProfileModel.email}"}
    };
    String payload = json.encode(data);
    http.Response response = await http
        .post(Uri.parse('https://api.paystack.co/transaction/initialize'),
            headers: headers, body: payload)
        .timeout(const Duration(seconds: 30));
    var data2 = jsonDecode(response.body);
    // print(data2.toString());
    String accessCode = data2['data']['access_code'];
    String authUrl = data2['data']['authorization_url'];
    return authUrl;
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

  static void verifyOnServerDiamond(
    String reference,
    context,
  ) async {
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
        GiftWare.instance.getGiftFromApi();
        GiftWare.instance.getWalletFromApi();
        Get.back();
        Get.dialog(diamondDialog(
            title: "You just Got some Diamonds ",
            message: "Diamonds has been added to your wallet",
            confirmText: "Okay",
            cancelText: "Go back",
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));

        // log("paid");

        //do something with the response. show success}
        //show error prompt}
        return;
      } else {
        try {
          showToast2(context, "Payment not verified try again", isError: true);
        } catch (e) {}
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
