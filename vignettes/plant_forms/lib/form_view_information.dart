import 'package:flutter/material.dart';

import 'components/section_title.dart';
import 'components/stack_pages_route.dart';
import 'components/submit_button.dart';
import 'demo_data.dart';
import 'form_inputs/dropdown_menu.dart';
import 'form_inputs/text_input.dart';
import 'form_mixin.dart';
import 'form_page.dart';
import 'form_view_payment.dart';
import 'form_view_summary.dart';
import 'styles.dart';

class PersonalInformationForm extends StatefulWidget {
  final double pageSize;
  final bool isHidden;
  final Map<String, String> formValues;

  const PersonalInformationForm({Key key, this.pageSize, this.isHidden = false, this.formValues}) : super(key: key);

  @override
  _PersonalInformationFormState createState() => _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> with FormMixin {
  final _formKey = GlobalKey<FormState>();

  Map<String, String> get values => widget.formValues;

  List<Widget> _formElements;
  String _country;
  String _countrySubdivision;

  @override
  void initState() {
    super.initState();
    var value = _getInitialValue('Country / Region');
    _country = value.isEmpty ? DemoData().getCountries()[2] : _getInitialValue('Country / Region');
    _updateCountrySubdivision(_country);
    _initFormElements();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding information @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      formKey: _formKey,
      isHidden: widget.isHidden,
      pageSizeProportion: widget.pageSize ?? 0.85,
      title: 'Information',
      children: <Widget>[
        FormSectionTitle('Contact Information'),
        TextInput(
            helper: 'Email',
            initialValue: _getInitialValue('Email'),
            type: InputType.email,
            onValidate: onItemValidate,
            onChange: onItemChange),
        FormSectionTitle('Shipping Address'),
        DropdownMenu(
          label: 'Country / Region',
          options: DemoData().getCountries(),
          defaultOption: _country,
          onValidate: onItemValidate,
        ),
        for (var input in _formElements) input,
        TextInput(
            key: _getKey('phone'),
            helper: 'Phone Number',
            initialValue: _getInitialValue('Phone Number'),
            isRequired: false,
            type: InputType.telephone,
            onChange: onItemChange,
            onValidate: onItemValidate),
        SubmitButton(
            isErrorVisible: isFormErrorVisible,
            child: Text('Continue to payment', style: Styles.submitButtonText),
            percentage: formCompletion,
            onPressed: () => _handleSubmit(context)),
      ],
    );
  }

  @override
  void onItemValidate(String name, bool isValid, {String value}) {
    validInputsMap[name] = isValid;
    values[name] = value;

    // on country updated
    if (name == 'Country / Region' && value != _country) {
      validInputsMap.clear();
      onItemChange(name, value);
      _updateCountrySubdivision(value);
    }

    // update form status
    Future.delayed(Duration(milliseconds: 500), () {
      if (this.mounted)
        setState(() {
          formCompletion = countValidItems() / validInputsMap.length;
          if (formCompletion == 1) isFormErrorVisible = false;
        });
    });
  }

  @override
  //Update cached values each time the form changes
  void onItemChange(String name, String value) {
    values[name] = value;
  }

  void _initFormElements() {
    switch (_country) {
      case 'Canada':
        _formElements = [
          TextInput(
            key: _getKey('first_name'),
            helper: 'First Name',
            initialValue: _getInitialValue('First Name'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('last_name'),
            helper: 'Last Name',
            initialValue: _getInitialValue('Last Name'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('address'),
            helper: 'Address',
            initialValue: _getInitialValue('Address'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('apt'),
            helper: 'Apartment, suite, etc.',
            initialValue: _getInitialValue('Apartment, suite, etc.'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('city'),
            helper: 'City',
            initialValue: _getInitialValue('City'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          DropdownMenu(
              key: _getKey(_countrySubdivision),
              label: _countrySubdivision,
              options: DemoData().getSubdivisionList(_countrySubdivision),
              onValidate: onItemValidate),
          TextInput(
            key: _getKey('postal'),
            helper: 'Postal Code',
            initialValue: _getInitialValue('Postal Code'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
        ];
        break;
      case 'United States':
        _formElements = [
          TextInput(
            key: _getKey('first_name'),
            helper: 'First Name',
            initialValue: _getInitialValue('First Name'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('last_name'),
            helper: 'Last Name',
            initialValue: _getInitialValue('Last Name'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('address'),
            helper: 'Address',
            initialValue: _getInitialValue('Address'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('apt'),
            helper: 'Apartment, suite, etc.',
            initialValue: _getInitialValue('Apartment, suite, etc.'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('city'),
            helper: 'City',
            initialValue: _getInitialValue('City'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          DropdownMenu(
              key: _getKey(_countrySubdivision),
              label: _countrySubdivision,
              options: DemoData().getSubdivisionList(_countrySubdivision),
              onValidate: onItemValidate),
          TextInput(
            key: _getKey('postal'),
            helper: 'Zip Code',
            initialValue: _getInitialValue('Zip Code'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
        ];
        break;
      case 'Japan':
        _formElements = [
          TextInput(
            key: _getKey('company'),
            helper: 'Company',
            initialValue: _getInitialValue('Company'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('last_name'),
            helper: 'Last Name',
            initialValue: _getInitialValue('Last Name'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('first_name'),
            helper: 'First Name',
            initialValue: _getInitialValue('First Name'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('postal'),
            helper: 'Postal Code',
            initialValue: _getInitialValue('Postal Code'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          DropdownMenu(
              key: _getKey(_countrySubdivision),
              label: _countrySubdivision,
              options: DemoData().getSubdivisionList(_countrySubdivision),
              onValidate: onItemValidate),
          TextInput(
            key: _getKey('city'),
            helper: 'City',
            initialValue: _getInitialValue('City'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('address'),
            helper: 'Address',
            initialValue: _getInitialValue('Address'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('apt'),
            helper: 'Apartment, suite, etc.',
            initialValue: _getInitialValue('Apartment, suite, etc.'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
        ];
        break;

      case 'France':
        _formElements = [
          TextInput(
            key: _getKey('first_name'),
            helper: 'First Name',
            initialValue: _getInitialValue('First Name'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('last_name'),
            helper: 'Last Name',
            initialValue: _getInitialValue('Last Name'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('company'),
            helper: 'Company',
            initialValue: _getInitialValue('Company'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('address'),
            helper: 'Address',
            initialValue: _getInitialValue('Address'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('apt'),
            helper: 'Apartment, suite, etc.',
            initialValue: _getInitialValue('Apartment, suite, etc.'),
            isRequired: false,
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('postal'),
            helper: 'Postal Code',
            initialValue: _getInitialValue('Postal Code'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
          TextInput(
            key: _getKey('city'),
            helper: 'City',
            initialValue: _getInitialValue('City'),
            onValidate: onItemValidate,
            onChange: onItemChange,
          ),
        ];
        break;
    }
  }

  ValueKey _getKey(String name) {
    return ValueKey("$name-$_country");
  }

  String _getInitialValue(String name) {
    return values.containsKey(name) ? values[name] ?? "" : "";
  }

  void _updateCountrySubdivision(String country) {
    validInputsMap.clear();
    _country = country;
    _countrySubdivision = DemoData().getSubdivisionTitle(country);
    _initFormElements();
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState.validate() && formCompletion == 1) {
      Navigator.push(
          context,
          StackPagesRoute(previousPages: [
            OrderSummaryForm(
              formValues: values,
              isHidden: true,
              pageSize: .85,
            ),
            PersonalInformationForm(
              formValues: values,
              isHidden: true,
              pageSize: .85,
            )
          ], enterPage: PaymentFormPage(formValues: values)));
    } else
      setState(() {
        isFormErrorVisible = true;
      });
  }
}
