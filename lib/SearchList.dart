import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:THAS/servidor.dart';
import 'package:THAS/tela_produto.dart';

class SearchList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffold;

  SearchList({Key key, @required this.scaffold}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SearchList> {
  TextEditingController editingController = TextEditingController();
  ScrollController _scrollController;
  List<String> duplicateItems = new List();
  var items = List<String>();
  double _containerMaxHeight = 56, _offset, _delta = 0, _oldOffset = 0;

  @override
  void initState() {
    super.initState();
    Servidor().get("produtos", widget.scaffold).then((resp) {
      List<dynamic> lugares = jsonDecode(resp);

      List<String> lug = new List();

      List<String> list = lugares.map((e) {
        lug.add(e['nome'].toString());
        return e['nome'].toString();
      }).toList();

      if (mounted) {
        setState(() {
          duplicateItems.addAll(list);
          items.addAll(duplicateItems);
        });
      }
    });

    _offset = 0;
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          double offset = _scrollController.offset;
          _delta += (offset - _oldOffset);
          if (_delta > _containerMaxHeight)
            _delta = _containerMaxHeight;
          else if (_delta < 0) _delta = 0;
          _oldOffset = offset;
          _offset = -_delta;
        });
      });
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Equipamentos",
                  hintText: "Equipamentos",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${items[index]}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TelaProduto(
                                  nomeProduto: items[index],
                                )));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
