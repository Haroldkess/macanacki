import 'package:flutter/material.dart';
import 'package:macanacki/presentation/purchase_ext.dart';
class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }


  Future fetchOffers(BuildContext context) async {
    final offerings = await PurchaseExt.fetchOffers();
    if(offerings.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Plans found')));
    }else{
      final offer = offerings.first;
      print('Offer: $offer ');
    }

  }
}
