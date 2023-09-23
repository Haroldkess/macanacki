import 'package:flutter/material.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

optionModal(
  BuildContext cont,
) async {
  bool pay = true;
  return showModalBottomSheet(
      context: cont,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // PlanWare stream = context.watch<PlanWare>();
        // UserProfileWare user = context.watch<UserProfileWare>();
        // PlanWare action = Provider.of<PlanWare>(context,listen: false);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class GiveModel {
  String? diamonds;
  String? amount;
  GiveModel({required this.diamonds, required this.amount});
}

List<GiveModel> give = [
  GiveModel(diamonds: "50", amount: "\$0.00"),
  GiveModel(diamonds: "50", amount: "\$0.00"),
  GiveModel(diamonds: "50", amount: "\$0.00")
];
