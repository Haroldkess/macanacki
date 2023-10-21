import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'pay_constant.dart';
import 'pay_styles.dart';

class Paywall extends StatefulWidget {
  final List<Package> packages;
  final String title;
  final String description;
  final Function() onSucess;
  final Function(String) onError;

  const Paywall({Key? key, required this.packages, required this.title, required this.description, required this.onSucess, required this.onError}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  bool progressVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(darkColor),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Wrap(
            children: <Widget>[
              _buildHeaderField(context),

              _buildPackagesField(context),
              //
              _buildFooterField(context),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPackagesField(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ListView.builder(
        itemCount: widget.packages.length,
        itemBuilder: (BuildContext context, int index) {
          var myProduct = widget.packages[index];
          return Card(
            color: HexColor('#F5F5F5').withOpacity(0.07),
            child: ListTile(
                onTap: () async {
                  try {
                    setState(() {
                      progressVisibility = true;
                    });
                    await Purchases.purchasePackage(
                        myProduct);
                    widget.onSucess();


                  } catch (e) {
                    print("******************* ${e.toString()}");
                    widget.onError(e.toString());

                  }finally{
                    setState(() {
                      progressVisibility = false;
                    });
                  }
                },
                title: Text(
                  myProduct.storeProduct.title,
                  style: kTitleTextStyle,
                ),
                subtitle: Text(
                  myProduct.storeProduct.description,
                  style: kDescriptionTextStyle.copyWith(
                      fontSize: kFontSizeSuperSmall),
                ),
                trailing: Text(
                    myProduct.storeProduct.priceString,
                    style: kTitleTextStyle)),
          );
        },
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }



  Widget _buildFooterField(BuildContext context){
    // return Padding(
    //   padding:
    //   EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
    //   child: SizedBox(
    //     child: Text(
    //       footerText,
    //       style: kDescriptionTextStyle,
    //     ),
    //     width: double.infinity,
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Column(
        children: [
          const Icon(Icons.keyboard_arrow_down_outlined, size: 30,
            color: Colors.white,),
          const SizedBox(height: 10,),
          Text(termAndConditions,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueSpartan(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    decorationStyle: TextDecorationStyle.solid,
                    fontSize: 13,
                    height: 1.2
                  ))),
        ],
      ),
    );
  }

  Widget _buildHeaderField(BuildContext context){

    return Column(
      children: [


        Visibility(
          visible: progressVisibility == false,
          child: Container(
            width: double.infinity,
            height: 7,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.red,
            ),
          ),
        ),

        Visibility(
          visible: progressVisibility,
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: const Color(0xffF5F5F5).withOpacity(0.07),
            minHeight: 7,


            //  borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(11.0),
                decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5).withOpacity(0.07),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
              Text(widget.title,
              style: GoogleFonts.leagueSpartan(
              textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              decorationStyle: TextDecorationStyle.solid,
              fontSize: 17,
              fontFamily: '',
              ))),
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5).withOpacity(0.07),
                  shape: BoxShape.circle),
              child: Text(widget.packages.length.toString(),
                  style: GoogleFonts.leagueSpartan(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        decorationStyle: TextDecorationStyle.solid,
                        fontSize: 15,
                        fontFamily: '',
                      ))),
            ),
          ],
        ),

      ],
    );
  }
}