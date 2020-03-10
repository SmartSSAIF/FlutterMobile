import 'package:flutter/material.dart';

class DropMenu extends StatefulWidget {
  List<String> list;
  final String texto;
  ValueChanged<String> onDropChange;
  DropMenu(
      {Key key,
      @required this.list,
      @required this.texto,
      @required this.onDropChange})
      : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<DropMenu> {
  String dropdownValue;

  @override
  void initState() {
     super.initState();
    print("TEste ${widget.list[0]}");
    print("Tamanho da lista ${widget.list.length}");
    print("Lista ${widget.list}");
    
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(widget.texto),
        Card(
          color: Colors.transparent,
          elevation: 0,
          child: DropdownButton<String>(
             value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              widget.onDropChange(newValue);
              dropdownValue = newValue;
            });
          },
          items: widget.list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),)
      ],
    );
  }
}
