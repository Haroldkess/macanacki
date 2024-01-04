import 'package:country_state_picker/country_state_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';

import '../../services/controllers/swipe_users_controller.dart';
import '../../services/middleware/swipe_ware.dart';
import '../constants/colors.dart';
import '../constants/params.dart';
import '../uiproviders/screen/find_people_provider.dart';
import 'buttons.dart';
import 'loader.dart';

class FilterAddressModal extends StatefulWidget {
  const FilterAddressModal({super.key});

  @override
  State<FilterAddressModal> createState() => _FilterAddressModalState();
}

class _FilterAddressModalState extends State<FilterAddressModal> {
  String? state;
  String? country;

  final _cscPickerKey = GlobalKey<CSCPickerState>();
  String selectedCity = "";
  String selectedCountry = "";
  String selectedState = "";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    FindPeopleProvider action =
        Provider.of<FindPeopleProvider>(context, listen: false);
    FindPeopleProvider stream = context.watch<FindPeopleProvider>();
    SwipeWare filter = context.watch<SwipeWare>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          child: Container(
            //height: MediaQuery.of(context).size.height * .5,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            color: backgroundSecondary,
            child: Column(
              children: [
                const SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 0,
                    ),
                    AppText(
                      text: "Filter by location",
                      fontWeight: FontWeight.w500,
                      size: 15,
                      color: textWhite,
                    ),
                    GestureDetector(
                        onTap: () async {
                          SwipeWare swipe =
                              Provider.of<SwipeWare>(context, listen: false);
                          swipe.clearFilter();
                          PageRouting.popToPage(context);
                        },
                        child: AppText(
                          text: "Clear filter",
                          size: 11,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  color: theme.textTheme.titleLarge!.color,
                  thickness: 0.2,
                ),
                const SizedBox(
                  height: 10,
                ),
                CSCPicker(
                  key: _cscPickerKey,
                  layout: Layout.vertical,
                  countryDropdownLabel: "Select country",
                  stateDropdownLabel: "Select state",
                  cityDropdownLabel: "Select city",
                  flagState: CountryFlag.DISABLE,
                  defaultCountry: CscCountry.Nigeria,
                  currentCity:
                      filter.city.isEmpty ? "Select city" : filter.city,
                  currentState:
                      filter.state.isEmpty ? "Select state" : filter.state,
                  currentCountry: filter.country.isEmpty
                      ? "Select country"
                      : filter.country,
                  // showCities: false,
                  onCountryChanged: (country) {
                    if (country != "Select country") {
                      Operations.filterLocaton(context, country);
                    } else if (country == "Nigeria") {
                      Operations.filterLocaton(context, country);
                    }

                    // setState(() {
                    //   selectedCountry = country;
                    // });
                    // log(country);
                  },
                  onStateChanged: (state) {
                    if (state != "Select state") {
                      Operations.filterLocaton(context, null, state);
                    }

                    // setState(() {
                    //   selectedState = state!;
                    // });
                  },
                  onCityChanged: (city) {
                    if (city != "Select city") {
                      Operations.filterLocaton(context, null, null, city);
                    }

                    // setState(() {
                    //   selectedCity = city!;
                    // });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                AppButton(
                    width: 0.8,
                    height: 0.06,
                    color: backgroundColor,
                    text: "Continue",
                    backColor: backgroundColor,
                    curves: buttonCurves * 5,
                    textColor: "#FFFFFF",
                    onTap: () async {
                      SwipeWare swipe =
                          Provider.of<SwipeWare>(context, listen: false);
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        SwipeController.retrievSwipeController(
                          context,
                          swipe.filterName == "Women"
                              ? "female"
                              : swipe.filterName == "Men"
                                  ? "male"
                                  : swipe.filterName.toLowerCase(),
                          swipe.country,
                          swipe.state,
                          swipe.city,
                        );
                      });
                      PageRouting.popToPage(context);
                      //  _submit(context);
                      //  //  PageRouting.pushToPage(context, const EmailOtp());
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }
}

filterAdressModals(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterAddressModal();
      });
}
