import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/form.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';

import '../../../../../services/middleware/gift_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../operations.dart';
import '../../../../widgets/text.dart';
import '../diamond_modal/bank_list_modal.dart';

class WithdrawDiamonds extends StatelessWidget {
  const WithdrawDiamonds({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundSecondary,
        appBar: AppBar(
          backgroundColor: HexColor(backgroundColor),
          elevation: 0,
          leading: BackButton(
            color: textWhite,
          ),
          centerTitle: true,
          title: AppText(
            text: "Withdraw Diamond",
            color: textWhite,
            size: 24,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              BalanceCard(),
              SizedBox(
                height: 20,
              ),
              WithdrawalInput(),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  ObxValue((addedBank) {
                    return addedBank.value
                        ? Visibility(
                            visible: addedBank.value,
                            child: GestureDetector(
                              onTap: () {
                                myBankModal(context);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HexColor("#C0C0C0")),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.credit_card_rounded,
                                          color: HexColor(backgroundColor),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  AppText(
                                    text: "My Bank",
                                    size: 14,
                                    fontWeight: FontWeight.w400,
                                    color: textPrimary,
                                  ),
                                ],
                              ),
                            ))
                        : GestureDetector(
                            onTap: () {
                              bankModal(context);
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor("#C0C0C0")),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.add,
                                        color: HexColor(backgroundColor),
                                      )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AppText(
                                  text: "Add Bank",
                                  size: 14,
                                  fontWeight: FontWeight.w400,
                                  color: textPrimary,
                                ),
                              ],
                            ),
                          );
                  }, GiftWare.instance.localBankExist),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: 100,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            color: HexColor("#C0C0C0"),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppText(
                  text: "Balance",
                  size: 20,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ObxValue((gift) {
                      return Container(
                        constraints: BoxConstraints(maxWidth: 100),
                        child: AppText(
                          text:
                              "\$${Operations.convertToCurrency(((num.tryParse(gift.value.data.toString())! / 50) / 2).toString())}",
                          size: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }, GiftWare.instance.gift),
                    ObxValue((balance) {
                      return Row(
                        children: [
                          AppText(
                            text: "Diamond Received: ",
                            size: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          SvgPicture.asset(
                            "assets/icon/diamond.svg",
                            height: 10,
                            width: 10,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: AppText(
                              text: "${balance.value.data}",
                              size: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    }, GiftWare.instance.gift),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WithdrawalInput extends StatefulWidget {
  const WithdrawalInput({super.key});

  @override
  State<WithdrawalInput> createState() => _WithdrawalInputState();
}

class _WithdrawalInputState extends State<WithdrawalInput> {
  TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 200,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            color: HexColor("#C0C0C0"),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                AppFormWithdraw(
                  borderRad: 5.0,
                  backColor: Colors.transparent,
                  hint: "Enter Amount",
                  hintColor: textPrimary,
                  controller: amount,
                  textInputType: TextInputType.number,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: "withdrawal Limit",
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    AppText(
                      text: "\$100",
                      size: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ObxValue((loadWithdraw) {
                  return loadWithdraw.value
                      ? Visibility(
                          visible: loadWithdraw.value,
                          child: Center(
                            child: Loader(color: textWhite),
                          ))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ObxValue((balance) {
                              return InkWell(
                                onTap: () async {
                                  if (amount.text.isEmpty) {
                                    showToast2(context, "Input amount",
                                        isError: true);

                                    return;
                                  }
                                  if (num.tryParse(
                                          balance.value.data.toString())! <=
                                      1) {
                                    showToast2(context,
                                        "You can only withdraw this amount",
                                        isError: true);

                                    return;
                                  }

                                  GiftWare.instance
                                      .doWithdrawalFromApi(null, amount.text);
                                },
                                child: Column(
                                  children: [
                                    Visibility(
                                        visible: false,
                                        child: AppText(
                                            text:
                                                balance.value.data.toString())),
                                    Container(
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: HexColor(backgroundColor),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            }, GiftWare.instance.gift),
                            SizedBox(
                              height: 5,
                            ),
                            AppText(
                              text: "withdraw",
                              size: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        );
                }, GiftWare.instance.loadWithdrawal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
