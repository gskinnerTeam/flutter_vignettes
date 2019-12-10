import 'package:flutter/material.dart';

import 'form_view_information.dart';
import 'form_view_summary.dart';
import 'components/header.dart';
import 'components/stack_pages_route.dart';
import 'styles.dart';
import 'components/submit_button.dart';

class PlantFormsDemo extends StatefulWidget {
  @override
  _PlantFormsDemoState createState() => _PlantFormsDemoState();
}

class _PlantFormsDemoState extends State<PlantFormsDemo> {
  Map<String, String> currentFormValues = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Header(),
        OrderSummaryForm(),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: SubmitButton(
              padding: EdgeInsets.symmetric(horizontal: Styles.hzPadding),
              child: Text('Next', style: Styles.submitButtonText),
              onPressed: () => _handleSubmit(context),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    Navigator.push(
        context,
        StackPagesRoute(
            previousPages: [OrderSummaryForm(pageSize: .85, isHidden: true)],
            enterPage: PersonalInformationForm(
              formValues: currentFormValues
            )));
  }
}
