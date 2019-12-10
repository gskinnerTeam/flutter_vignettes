import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'form_inputs/checkbox_input.dart';
import 'form_inputs/credit_card_input.dart';
import 'form_mixin.dart';
import 'form_page.dart';
import 'components/section_separator.dart';
import 'components/section_title.dart';
import 'styles.dart';
import 'components/submit_button.dart';
import 'form_inputs/text_input.dart';

class PaymentFormPage extends StatefulWidget {
  final Map<String, String> formValues;
  final double pageSize;

  const PaymentFormPage({Key key, this.pageSize, @required this.formValues}) : super(key: key);
  @override
  _PaymentFormPageState createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> with FormMixin {
  final _formKey = GlobalKey<FormState>();
  CreditCardNetwork _cardNetwork;

  @override
  Widget build(BuildContext context) {
    print("Rebuilding payments @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      formKey: _formKey,
      pageSizeProportion: widget.pageSize ?? 0.85,
      title: 'Payment',
      children: [
        Text('\$34.00', style: Styles.orderTotal),
        Separator(),
        _buildShippingSection(),
        Separator(),
        FormSectionTitle('Gift card or discount code'),
        _buildInputWithButton(),
        FormSectionTitle('Payment', padding: EdgeInsets.only(bottom: 16)),
        CreditCardInfoInput(
          label: 'Card Number',
          helper: '4111 2222 3333 4440',
          cardNetwork: _cardNetwork,
          onValidate: onItemValidate,
          onChange: _handleItemChange,
          inputType: CreditCardInputType.number,
        ),
        TextInput(label: 'Card Name', helper: 'Cardholder Name', onValidate: onItemValidate),
        Row(
          children: <Widget>[
            Expanded(
                child: CreditCardInfoInput(
              label: 'Expiration',
              helper: 'MM/YY',
              onValidate: onItemValidate,
              inputType: CreditCardInputType.expirationDate,
            )),
            SizedBox(width: 24),
            Expanded(
              child: CreditCardInfoInput(
                  cardNetwork: _cardNetwork,
                  label: 'Security Code',
                  helper: '000',
                  onValidate: onItemValidate,
                  inputType: CreditCardInputType.securityCode),
            ),
          ],
        ),
        FormSectionTitle('Billing Address'),
        CheckBoxInput(label: 'Same as Shipping'),
        _buildSubmitButton()
      ],
    );
  }

  @override
  void onItemValidate(String name, bool isValid, {String value}) {
    validInputsMap[name] = isValid;
    widget.formValues[name] = value;

    Future.delayed(
      Duration(milliseconds: 500),
      () {
        if (this.mounted)
          setState(() {
            formCompletion = super.countValidItems() / validInputsMap.length;
            if (formCompletion == 1) isFormErrorVisible = false;
          });
      },
    );
  }

  Widget _buildShippingSection() {
    var details = widget.formValues;
    return Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(constraints: BoxConstraints(minWidth: 85), child: Text('Contact', style: Styles.orderLabel)),
          Text(details['Email'], overflow: TextOverflow.clip, style: Styles.orderPrice),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(constraints: BoxConstraints(minWidth: 85), child: Text('Ship to', style: Styles.orderLabel)),
            Text(_getShippingAddress(), overflow: TextOverflow.clip, style: Styles.orderPrice),
          ],
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(constraints: BoxConstraints(minWidth: 85), child: Text('Method', style: Styles.orderLabel)),
          Text('FREE', overflow: TextOverflow.clip, style: Styles.orderPrice),
        ],
      )
    ]);
  }

  String _getShippingAddress() {
    Map<String, String> details = widget.formValues;

    String aptNumber = details['Apartment, suite, etc.'].isNotEmpty ? '#${details['Apartment, suite, etc.']} ' : '';
    String address = details['Address'];
    String country = details['Country / Region'];
    String city = details['City'];
    String countrySubdivision = details[DemoData().getSubdivisionTitle(country)];
    String postalCode = details['Postal Code'] ?? details['Zip Code'];
    return '$aptNumber$address\n$city, $countrySubdivision ${postalCode.toUpperCase()}\n${country.toUpperCase()}';
  }

  Widget _buildInputWithButton() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 4,
            child: TextInput(
              helper: '000 000 000 XX',
              type: InputType.number,
              onValidate: onItemValidate,
              isRequired: false,
              isActive: false,
            )),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 26.0, left: 12),
            child: MaterialButton(
              disabledColor: Styles.lightGrayColor,
              elevation: 0,
              color: Styles.secondaryColor,
              height: 56,
              child: Text('Apply', style: Styles.submitButtonText),
              onPressed: null,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SubmitButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Purchase', style: Styles.submitButtonText),
            Text('\$34', style: Styles.submitButtonText),
          ],
        ),
      ),
      percentage: formCompletion,
      isErrorVisible: isFormErrorVisible,
      onPressed: _handleSubmit,
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState.validate() && formCompletion == 1) {
    } else
      setState(() => isFormErrorVisible = true);
  }

  void _handleItemChange(CreditCardNetwork cardNetwork) {
    setState(() => _cardNetwork = cardNetwork);
  }

  @override
  void onItemChange(String name, String value) => widget.formValues[name] = value;
}
