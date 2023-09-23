import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/form.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class WithdrawDiamonds extends StatelessWidget {
  const WithdrawDiamonds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: AppText(
          text: "Withdraw Diamond",
          color: Colors.black,
          size: 24,
        ),
      ),
      body: Column(
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
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: HexColor("#C0C0C0")),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: HexColor(primaryColor),
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AppText(
                    text: "Add Bank",
                    size: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          )
        ],
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
                    AppText(
                      text: "\$ 0.00",
                      size: 24,
                      fontWeight: FontWeight.w400,
                    ),
                    AppText(
                      text: "Diamond Received: 50,000",
                      size: 13,
                      fontWeight: FontWeight.w400,
                    ),
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

class WithdrawalInput extends StatelessWidget {
  const WithdrawalInput({super.key});

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
                AppForm(
                  borderRad: 5.0,
                  backColor: HexColor(backgroundColor),
                  hint: "Enter Amount",
                  hintColor: HexColor("#C0C0C0"),
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
                      text: "\$500",
                      size: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.remove,
                              color: HexColor(primaryColor),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AppText(
                      text: "withdraw",
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
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
