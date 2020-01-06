import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'demo_data.dart';
import 'flight_barcode.dart';
import 'flight_details.dart';
import 'flight_summary.dart';
import 'folding_ticket.dart';

class Ticket extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final BoardingPassData boardingPass;
  final Function onClick;

  const Ticket({Key key, @required this.boardingPass, @required this.onClick}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  FlightSummary frontCard;
  FlightSummary topCard;
  FlightDetails middleCard;
  FlightBarcode bottomCard;
  bool _isOpen;

  Widget get backCard =>
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: Color(0xffdce6ef)));

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    frontCard = FlightSummary(boardingPass: widget.boardingPass);
    middleCard = FlightDetails(widget.boardingPass);
    bottomCard = FlightBarcode();
  }

  @override
  Widget build(BuildContext context) {
    return FoldingTicket(entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 160.0, front: topCard),
      FoldEntry(height: 160.0, front: middleCard, back: frontCard),
      FoldEntry(height: 80.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    widget.onClick();
    setState(() {
      _isOpen = !_isOpen;
      topCard = FlightSummary(boardingPass: widget.boardingPass, theme: SummaryTheme.dark, isOpen: _isOpen);
    });
  }
}
