import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/convo/all_matched_screen.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/convo_search.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/convo_tab.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/matches.dart';
import 'package:makanaki/presentation/screens/home/convo/convoextra/messages.dart';
import 'package:makanaki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: AppText(
          text: "Conversations",
          color: HexColor(darkColor),
          size: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const ConvoSearch(),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                      onTap: () => PageRouting.pushToPage(
                          context, const SwipeCardScreen()),
                      child: const ConvoTab()),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Matches",
                        fontWeight: FontWeight.w400,
                        color: HexColor(darkColor),
                        size: 24,
                      ),
                      InkWell(
                        onTap: () => PageRouting.pushToPage(
                            context, const MatchedWithYouScreen()),
                        child: AppText(
                            text: "See All",
                            color: HexColor(primaryColor),
                            size: 14,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Matches(),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(
                        text: "Messages",
                        fontWeight: FontWeight.w400,
                        color: HexColor(darkColor),
                        size: 24,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AppText(
                            text: "2",
                            color: HexColor(backgroundColor),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: MessageList(),
            )
          ],
        ),
      ),
    );
  }
}
