import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:macanacki/model/user_balance.dart';
import 'package:macanacki/services/backoffice/gifts_office.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/bank_model.dart';
import '../../model/download_post_model.dart';
import '../../model/exchange_rate_model.dart';
import '../../model/gift_diamond_history_model.dart';
import '../../model/gift_wallet_balance.dart';
import '../../presentation/screens/home/diamond/diamond_modal/buy_modal.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/dialogue.dart';
import '../controllers/save_media_controller.dart';
import '../temps/temps_id.dart';

class GiftWare extends GetxController {
  static GiftWare get instance {
    return Get.find<GiftWare>();
  }

  Rx<UserBalanceModel> userBalance = UserBalanceModel().obs;
  Rx<GiftBalanceModel> gift = GiftBalanceModel().obs;
  Rx<GiftDiamondHistory> gifterHistory = GiftDiamondHistory().obs;
  Rx<ExchangeRateModel> rate = ExchangeRateModel().obs;
  Rx<BankModel> banks = BankModel().obs;
  Rx<LocalBankModel> myLocalBank = LocalBankModel().obs;
  Rx<bool> loadGifters = false.obs;
  Rx<bool> loadTransfer = false.obs;
  Rx<bool> loadWithdrawal = false.obs;
  Rx<bool> loadBank = false.obs;
  Rx<bool> localBankExist = false.obs;
  @override
  void onInit() {
    getWalletFromApi();
    getGiftFromApi();
    getFundWalletHistoryFromApi();
    getReceivedDiamondsHistoryFromApi();
    getExchangeRateFromApi();
    getBankListFromApi();
    getBankLocally();

    super.onInit();
  }

  Future<bool> getWalletFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await GiftCalls.walletBalance()
          .whenComplete(() => emitter("wallet  gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var data = UserBalanceModel.fromJson(jsonData);
        userBalance.value = data;

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    return isSuccessful;
  }

  Future<bool> getGiftFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await GiftCalls.giftBalance()
          .whenComplete(() => emitter("gift  gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var data = GiftBalanceModel.fromJson(jsonData);
        gift.value = data;

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    return isSuccessful;
  }

  Future<bool> getFundWalletHistoryFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await GiftCalls.fundWalletHistory()
          .whenComplete(
              () => emitter("fund wallet history  gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    return isSuccessful;
  }

  Future<bool> getReceivedDiamondsHistoryFromApi() async {
    late bool isSuccessful;
    loadGifters.value = true;
    try {
      http.Response? response = await GiftCalls.myRecievedDiamondsHistory()
          .whenComplete(() =>
              emitter("my Recieved Diamonds History  gotten successfully"));
      if (response == null) {
        loadGifters.value = false;
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var data = GiftDiamondHistory.fromJson(jsonData);
        gifterHistory.value = data;
        loadGifters.value = false;

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        loadGifters.value = false;

        isSuccessful = false;
      }
    } catch (e) {
      loadGifters.value = false;
      isSuccessful = false;
    }
    loadGifters.value = false;

    return isSuccessful;
  }

  Future<void> doTransferOfDiamondsFromApi(String name, String amount,
      String narration, BuildContext context) async {
    loadTransfer.value = true;
    late bool isSuccessful;
    Map data = {
      "value": amount,
      "receiver_username": name,
      "narrative": "gift",
    };
    try {
      http.Response? response = await GiftCalls.transferDiamonds(data)
          .whenComplete(() => emitter("transferDiamonds"));
      if (response == null) {
        loadTransfer.value = false;
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        loadTransfer.value = false;
        isSuccessful = true;
        getWalletFromApi();
        getGiftFromApi();
        Get.back();
        Get.dialog(diamondDialog(
            title: "You Gifted $name ",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));
      } else {
        var jsonData = jsonDecode(response.body);
        loadTransfer.value = false;
        isSuccessful = false;
        Get.back();
        Get.dialog(diamondDialog(
            title: "Failed to gift $name",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            isFail: true,
            // onPressedCancel: () {
            //   Get.back();
            // },
            // onPressed: () {
            //   buyDiamondsModal(context, rate.value.data);
            //   Get.back();
            // },
            context: context));
      }
    } catch (e) {
      loadTransfer.value = false;
      isSuccessful = false;
    }
  }

  Future<void> doWithdrawalFromApi(
    String? currency,
    String amount,
  ) async {
    loadWithdrawal.value = true;
    late bool isSuccessful;
    Map data = {
      "value": amount,
      "currency": currency ?? 'NGN',
    };
    try {
      http.Response? response = await GiftCalls.withdraw(data)
          .whenComplete(() => emitter("withdrawn"));
      if (response == null) {
        loadWithdrawal.value = false;
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        loadWithdrawal.value = false;
        isSuccessful = true;
        getWalletFromApi();
        getGiftFromApi();
        Get.back();
        Get.dialog(diamondDialog(
            title: "Withdrawal request sent ",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));
      } else {
        var jsonData = jsonDecode(response.body);
        loadWithdrawal.value = false;
        isSuccessful = false;
        Get.back();
        Get.dialog(diamondDialog(
            title: "Withdrawal request failed",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            isFail: true,
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));
      }
    } catch (e) {
      loadWithdrawal.value = false;
      isSuccessful = false;
    }
  }

  Future<bool> getExchangeRateFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await GiftCalls.exchangeRate()
          .whenComplete(() => emitter("exchange  gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var data = ExchangeRateModel.fromJson(jsonData);
        rate.value = data;

        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    return isSuccessful;
  }

  Future<bool> getBankListFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await GiftCalls.listBank()
          .whenComplete(() => emitter("bank  gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var data = BankModel.fromJson(jsonData);
        banks.value = data;
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    return isSuccessful;
  }

  Future<void> doAddLocalBankFromApi(
      int id, String number, String name, String bankName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data2 = {
      "bank_id": "$id",
      "account_number": number,
      "account_name": name,
      "bank_name": bankName,
    };
    pref.setString(bankInfo, jsonEncode(data2));
    pref.setBool(bankAdded, true);

    getBankLocally();
  }

  Future<void> doAddBankFromApi(
      int id, String number, String name, String bankName) async {
    loadBank.value = true;
    late bool isSuccessful;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      "bank_id": "$id",
      "account_number": number,
      "account_name": name,
    };
    Map data2 = {
      "bank_id": "$id",
      "account_number": number,
      "account_name": name,
      "bank_name": bankName,
    };
    try {
      http.Response? response = await GiftCalls.addBank(data)
          .whenComplete(() => emitter("transferDiamonds"));
      if (response == null) {
        loadBank.value = false;
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        pref.setString(bankInfo, jsonEncode(data2));
        pref.setBool(bankAdded, true);

        loadBank.value = false;
        isSuccessful = true;
        doAddLocalBankFromApi(id, number, name, bankName);
        getWalletFromApi();
        getGiftFromApi();
        Get.back();
        Get.dialog(bankDialog(
            title: "Bank added successfully",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));
      } else {
        var jsonData = jsonDecode(response.body);
        loadBank.value = false;
        isSuccessful = false;
        doAddLocalBankFromApi(id, number, name, bankName);
        Get.back();
        Get.dialog(diamondDialog(
            title: "Failed to add bank",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            isFail: true,
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));
      }
    } catch (e) {
      loadBank.value = false;
      isSuccessful = false;
    }
  }

  Future getBankLocally() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(bankAdded)) {
      localBankExist.value = pref.getBool(bankAdded)!;
    }
    if (pref.containsKey(bankInfo)) {
      try {
        var data = pref.getString(bankInfo);
        log(data.toString());

        var convertData = jsonDecode(data!);
        // log(convertData.toString());

        var local = LocalBankModel.fromJson(convertData);
        myLocalBank.value = local;
        log(myLocalBank.value.accountNumber.toString());
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<bool> giftForDownloadFromApi(int id, context) async {
    late bool isSuccessful;
    try {
      http.Response? response = await GiftCalls.downloadPost(id)
          .whenComplete(() => emitter("gift  gotten successfully"));
      if (response == null) {
        isSuccessful = false;
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        try {
          var data = DownloadModel.fromJson(jsonData);
          if (data.data!.media!.length > 1) {
            await Future.forEach(data.data!.media!, (element) async {
              if (element.isNotEmpty) {
                try {
                  if (element.contains('.mp4')) {
                    await SaveMediaController.saveNetworkVideo(
                        context, element);
                  } else {
                    await SaveMediaController.saveNetworkImage(
                        context, element);
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            });
          } else {
            if (data.data!.media!.first.contains('.mp4')) {
              await SaveMediaController.saveNetworkVideo(
                  context, data.data!.media!.first);
            } else {
              await SaveMediaController.saveNetworkImage(
                  context, data.data!.media!.first);
            }
          }
        } catch (e) {
          log(e.toString());
        }

        // gift.value = data;
//
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);

        Get.dialog(diamondDialog(
            title: "Can not download ",
            message: "${jsonData["message"]}",
            confirmText: "Okay",
            cancelText: "Go back",
            onPressedCancel: () {
              Get.back();
            },
            onPressed: () {
              Get.back();
            }));

        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    }

    return isSuccessful;
  }
}
