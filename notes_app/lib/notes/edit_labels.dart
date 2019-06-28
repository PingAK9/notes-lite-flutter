import 'package:flutter/material.dart';
import 'package:flutter_notes_app/datas/notes_datas.dart';

class EditLabels extends StatefulWidget {
  @override
  _EditLabelsState createState() => _EditLabelsState();
}

class _EditLabelsState extends State<EditLabels> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    loadLabelData().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: new Text(
          'Edit labels',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[buildEditField(), buildListLabels()],
      ),
    );
  }

  Widget buildListLabels() {
    if (labelDatas == null) {
      return Container(
        padding: EdgeInsets.all(20),
        height: 50,
        alignment: Alignment.centerLeft,
        child: Text('Loading...'),
      );
    } else {
      int _count = labelDatas.length;
      return Expanded(
        child: Container(
          child: ListView.builder(
              itemCount: _count,
              itemBuilder: (BuildContext context, int index) {
                return buildLablelTile(labelDatas[index]);
              }),
        ),
      );
    }
  }

  Container buildEditField() {
    var txt = new TextEditingController();
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                txt.text = '';
              }),
          Expanded(
            child: TextField(
              controller: txt,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Create new label'),
              keyboardType: TextInputType.text,
            ),
          ),
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                if (txt.text.isNotEmpty) {
                  addNewLabel(txt.text);
                  txt.text = '';
                  setState(() {});
                }
              }),
        ],
      ),
    );
  }

  int currentID = -1;
  var currentText = new TextEditingController();
  static const List<Color> defaultColors = [
    Colors.grey,
    Colors.brown,
    Colors.blueGrey,
    Colors.deepPurple,
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.pink
  ];

  Widget buildLablelTile(LabelUnit _label) {
    if (_label.id == currentID) {
      return Container(
          height: 100,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: ListView.builder(
                  itemCount: 16,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 1),
                      child: FloatingActionButton(
                        elevation: 0,
                        onPressed: () {
                          setState(() {
                            _label.setColor(defaultColors[index]);
                            saveLabelData();
                          });
                        },
                        backgroundColor: defaultColors[index],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.label,
                      color: _label.getColor(),
                      size: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextField(
                          controller: currentText,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Edit label name',
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.restore_from_trash,
                        color: Colors.black26,
                        size: 20,
                      ),
                      onPressed: () {
                        removeLabel(_label.id);
                        setState(() {
                          currentID = -1;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.black26,
                        size: 20,
                      ),
                      onPressed: () {
                        _label.title = currentText.text;
                        updateLabel(_label);
                        setState(() {
                          currentID = -1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ));
    } else {
      return Container(
        height: 50,
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.label,
              color: _label.getColor(),
              size: 20,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                _label.title,
                softWrap: true,
                maxLines: 1,
              ),
            )),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black26,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  currentID = _label.id;
                  currentText.text = _label.title;
                });
              },
            ),
          ],
        ),
      );
    }
  }
}
