import 'package:flutter/material.dart';

import '../styles.dart';

class FormDropdownMenu extends StatefulWidget {
  final void Function(String key, String value, bool isValid) onValidate;
  final String label;
  final String defaultOption;
  final List<String> options;

  const FormDropdownMenu({
    Key? key,
    required this.options,
    required this.label,
    required this.onValidate,
    required this.defaultOption,
  }) : super(key: key);

  @override
  _FormDropdownMenuState createState() => _FormDropdownMenuState();
}

class _FormDropdownMenuState extends State<FormDropdownMenu> {
  String _selectedOption = '';
  bool _isValid = false;
  String get _keyValue => (widget.key as ValueKey).value as String;

  set isValid(bool value) {
    if (_isValid == value) return;
    _isValid = value;
    widget.onValidate(_keyValue, _selectedOption, _isValid);
  }

  @override
  initState() {
    super.initState();
    _selectedOption = widget.defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    if (_isValid && _selectedOption.isNotEmpty) {
      isValid = true;
    }
    var items = _buildMenuItems();
    //items.forEach((i)=>print("----> ${i.value}"));

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        DropdownButtonFormField<String>(
          key: UniqueKey(),
          onChanged: (val) {},
          value: _selectedOption,
          items: items,
          validator: _validate,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Styles.secondaryColor)),
            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Styles.errorColor)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Styles.lightGrayColor)),
            border: OutlineInputBorder(),
            errorStyle: TextStyle(color: Colors.transparent),
            helperText: '',
            hintText: widget.label,
            hintStyle: Styles.helperStyle,
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          child: Text('▼', style: Styles.iconDropdown),
        ),
        GestureDetector(
          onTap: _showOptions,
          child: Container(
            width: double.infinity,
            height: 60,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildMenuItems() {
    var items = widget.options.map((o) {
      return DropdownMenuItem(
        value: o,
        child: Text(o, style: Styles.orderTotalLabel),
      );
    }).toList();
    return items;
  }

  String? _validate(value) {
    if (value == null)
      return 'there is an error';
    else
      return null;
  }

  _showOptions() async {
    _selectedOption = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DropdownOptions(
                title: widget.label,
                selectedOption: _selectedOption,
                options: widget.options,
              ),
            )) ??
        _selectedOption;
    if (_selectedOption.isNotEmpty) isValid = true;
    setState(() {});
  }
}

class DropdownOptions extends StatefulWidget {
  final String title;
  final List<String> options;
  final String selectedOption;

  const DropdownOptions({Key? key, required this.title, required this.options, required this.selectedOption})
      : super(key: key);

  @override
  _DropdownOptionsState createState() => _DropdownOptionsState();
}

class _DropdownOptionsState extends State<DropdownOptions> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedOption = '';
  @override
  void initState() {
    _selectedOption = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(child: Text(widget.title, style: Styles.optionsTitle)),
        actions: <Widget>[
          TextButton(
            child: Text('Done', style: Styles.textButton),
            onPressed: _sendSelectedOption,
          ),
        ],
      ),
      backgroundColor: Color(0xfff4f4f4),
      body: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Styles.grayColor))),
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[for (String option in widget.options) _buildOption(option)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    return GestureDetector(
      onTap: () => _selectOption(option),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        decoration:
            BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Styles.lightGrayColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(option, style: Styles.orderTotalLabel),
            Icon(Icons.check, color: _selectedOption == option ? Styles.secondaryColor : Colors.transparent, size: 40)
          ],
        ),
      ),
    );
  }

  void _sendSelectedOption() {
    if (_selectedOption.isNotEmpty)
      Navigator.pop(context, _selectedOption);
    else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select one of the options')));
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }
}
