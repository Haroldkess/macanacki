import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';

import '../../profile/profileextras/not_mine_buttons.dart';
import '../diamond_modal/buy_modal.dart';
import '../gifters/myGifters.dart';
import '../withdrawal/withdraw_screen.dart';

class DiamondBalanceScreen extends StatelessWidget {
  const DiamondBalanceScreen({super.key});

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
          text: "Balance",
          color: Colors.black,
          size: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            BalanceCard(),
            SizedBox(
              height: 10,
            ),
            RevenueCard(),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          PageRouting.pushToPage(context, const MyGifters());
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: HexColor("#C0C0C0"),
                              shape: BoxShape.circle),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icon/follow.svg",
                              color: HexColor(primaryColor),
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      AppText(
                        text: "My Gifters",
                        size: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
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
    return Container(
      height: 100,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: HexColor("#C0C0C0"), borderRadius: BorderRadius.circular(12)),
      child: ObxValue((balance) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "${balance.value.data}",
                  size: 24,
                  fontWeight: FontWeight.w400,
                ),
                GestureDetector(
                  onTap: () => buyDiamondsModal(context),
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          color: HexColor(primaryColor),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      }, GiftWare.instance.gift),
    );
  }
}

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ObxValue((giftValue) {
      return Stack(
        //alignment: Alignment.centerRight,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 70,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  color: HexColor("#C0C0C0"),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Diamond Revenue",
                        size: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: AppText(
                          text: "\$${giftValue.value.data}",
                          size: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: -0,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: InkWell(
                onTap: () {
                  PageRouting.pushToPage(context, const WithdrawDiamonds());
                },
                child: Align(
                  alignment: Alignment.centerRight,
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
              ),
            ),
          )
        ],
      );
    }, GiftWare.instance.userBalance);
  }
}
