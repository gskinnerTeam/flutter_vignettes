import 'package:flutter/material.dart';

import '../styles.dart';

class FormSectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsets padding;

  const FormSectionTitle(this.title, {this.padding = const EdgeInsets.all(0), Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0).add(padding),
      child: Text(title.toUpperCase(), style: Styles.formSection),
    );
  }
}
