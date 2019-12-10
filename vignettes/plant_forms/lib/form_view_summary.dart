import 'package:flutter/material.dart';

import 'form_page.dart';
import 'components/section_separator.dart';
import 'main.dart';
import 'styles.dart';

class OrderSummaryForm extends StatelessWidget {
  final double pageSize;
  final bool isHidden;
  final Map<String, String> formValues;

  const OrderSummaryForm({Key key, this.pageSize, this.isHidden = false, this.formValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Rebuilding Summary @ ${DateTime.now().millisecondsSinceEpoch}");
    return FormPage(
      pageSizeProportion: pageSize ?? 0.85,
      isHidden: isHidden,
      title: 'Order Summary',
      children: <Widget>[
        _buildOrderSummary(),
        Separator(),
        _buildOrderInfo(),
        Separator(),
        _buildOrderTotal(),
        _buildOrderSpecialInstructions(),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                  border: Border.all(color: Styles.grayColor),
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(image: AssetImage('images/plant_header_background.png', package: App.pkg))),
            ),
            Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Styles.grayColor,
                  ),
                  child: Center(child: Text('1', style: Styles.imageBatch)),
                )),
          ],
        ),
        SizedBox(width: 36),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Red Potted \nPlant w/ \nWhite Bowl', style: Styles.productName),
            Text('\$34.00', style: Styles.productPrice)
          ],
        )
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Subtotal', style: Styles.orderLabel),
            Text('\$34.00', style: Styles.orderPrice),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Shipping', style: Styles.orderLabel),
            Text('FREE', style: Styles.orderPrice),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTotal() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Total', style: Styles.orderTotalLabel),
          Text('\$34.00', style: Styles.orderTotal),
        ],
      ),
    );
  }

  Widget _buildOrderSpecialInstructions() {
    return TextFormField(
      style: Styles.inputLabel,
      decoration: Styles.getInputDecoration(helper: 'Special Instructions'),
      minLines: 4,
      maxLines: 6,
    );
  }
}
