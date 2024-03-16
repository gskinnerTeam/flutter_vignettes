import 'package:flutter/material.dart';
import 'package:plant_forms/form_pages/plant_form_payment.dart';
import 'package:provider/provider.dart';

import 'components/header.dart';
import 'components/stack_pages_route.dart';

class PlantFormsDemo extends StatefulWidget {
  @override
  _PlantFormsDemoState createState() => _PlantFormsDemoState();
}

class SharedFormState {
  Map<String, String> valuesByName = {};

  SharedFormState();
}

class _PlantFormsDemoState extends State<PlantFormsDemo> {
  GlobalKey<NavigatorState> navKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Header(),
        //Use provider to pass down a FormState to each of the form views, this way they can easily share and update the same state object
        Provider<SharedFormState>(
          create: (_) => SharedFormState(),
          //Use WillPopScope to intercept hardware back taps, and instead pop the nested navigator
          child: WillPopScope(
            onWillPop: _handleBackPop,
            //Use a nested navigator to group the 3 form views under 1 parent view
            child: Navigator(
              key: navKey,
              onGenerateRoute: (route) {
                return StackPagesRoute(
                  previousPages: [],
                  //enterPage: PlantFormSummary(),
                  enterPage: PlantFormPayment(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _handleBackPop() async {
    if (navKey.currentState?.canPop() == true) {
      navKey.currentState?.pop();
    }
    return true;
  }
}
