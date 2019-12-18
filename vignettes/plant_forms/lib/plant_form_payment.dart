import 'package:flutter/material.dart';
import 'package:plant_forms/demo.dart';
import 'package:provider/provider.dart';

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

class PlantFormPayment extends StatefulWidget {
  final double pageSize;

  const PlantFormPayment({Key key, this.pageSize}) : super(key: key);
  @override
  _PlantFormPaymentState createState() => _PlantFormPaymentState();
}

class _PlantFormPaymentState extends State<PlantFormPayment> with FormMixin {
  final _formKey = GlobalKey<FormState>();
  CreditCardNetwork _cardNetwork;

  SharedFormState sharedState;
  Map<String, String> get values => sharedState.valuesByName;

  @override
  void initState() {
    sharedState = Provider.of<SharedFormState>(context, listen: false);
    super.initState();
  }

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
          key: ValueKey(FormKeys.ccNumber),
          label: 'Card Number',
          helper: '4111 2222 3333 4440',
          cardNetwork: _cardNetwork,
          onValidate: onItemValidate,
          onChange: _handleItemChange,
          inputType: CreditCardInputType.number,
        ),
        TextInput(
            key: ValueKey(FormKeys.ccName), label: 'Card Name', helper: 'Cardholder Name', onValidate: onItemValidate),
        Row(
          children: <Widget>[
            Expanded(
                child: CreditCardInfoInput(
              key: ValueKey(FormKeys.ccExpDate),
              label: 'Expiration',
              helper: 'MM/YY',
              onValidate: onItemValidate,
              inputType: CreditCardInputType.expirationDate,
            )),
            SizedBox(width: 24),
            Expanded(
              child: CreditCardInfoInput(
                  key: ValueKey(FormKeys.ccCode),
                  cardNetwork: _cardNetwork,
                  label: 'Security Code',
                  helper: '000',
                  onValidate: onItemValidate,
                  inputType: CreditCardInputType.securityCode),
            ),
          ],
        ),
        FormSectionTitle('Shipping Notifications'),
        CheckBoxInput(label: 'Send shipping updates via email'),
        _buildSubmitButton()
      ],
    );
  }

  @override
  void onItemValidate(String key, bool isValid, {String value}) {
    validInputsMap[key] = isValid;
    values[key] = value;

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
    return Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(constraints: BoxConstraints(minWidth: 85), child: Text('Contact', style: Styles.orderLabel)),
          Text(values[FormKeys.email], overflow: TextOverflow.clip, style: Styles.orderPrice),
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
    String aptNumber = values[FormKeys.apt].isNotEmpty ? '#${values[FormKeys.apt]} ' : '';
    String address = values[FormKeys.address];
    String country = values[FormKeys.country];
    String city = values[FormKeys.city];
    String countrySubdivision = values[CountryData.getSubdivisionTitle(country)] ?? '';
    String postalCode = values[FormKeys.postal];
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
  void onItemChange(String name, String value) => values[name] = value;
}
