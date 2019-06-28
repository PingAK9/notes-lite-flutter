import 'package:flutter/material.dart';
import 'package:flutter_notes_app/datas/notes_datas.dart';
import 'package:flutter_notes_app/notes/notes_list.dart';

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 130.0,
          child: DrawerHeader(
              child: Center(
                  child: Text('Notes Lite',
                      style: TextStyle(color: Colors.white, fontSize: 30))),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0)),
        ),
        buildListTile(Icons.edit, 'All notes', () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => NotesList(-1)),
                  (Route<dynamic> route) => false);
        }),
        buildLine(),
        buildLabels(),
//        buildLine(),
//        buildListTile(Icons.restore_from_trash, 'Trash', () {}),
//        buildListTile(Icons.settings, 'Setting', () {})
      ],
    ),
  );
}

Widget buildLabels() {
  if (labelDatas == null) {
    return Text('Loading...');
  } else {
    int _heightPerItem = 57;
    int _count = labelDatas.length + 2;
    return Container(
      height: (_count * _heightPerItem).toDouble(),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
            itemCount: _count,
            addRepaintBoundaries: false,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0, 8),
                  child: Text('LABELS',
                      style: Theme.of(context).textTheme.subhead),
                );
              } else if (index == (_count - 1)) {
                return buildListTile(Icons.add, 'Create new label', () {
                  Navigator.pushNamed(context, '/editLabels');
                });
              } else {
                return buildLablelTile(context, labelDatas[index - 1]);
              }
            }),
      ),
    );
  }
}

Container buildLine() {
  return Container(
    height: 1,
    color: Colors.black26,
  );
}

ListTile buildListTile(
    IconData _icon, String _title, GestureTapCallback _onTap) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          _icon,
          color: Colors.black26,
          size: 20,
        ),
        Spacer(flex: 1),
        Text(_title),
        Spacer(flex: 20),
      ],
    ),
    onTap: _onTap,
  );
}

ListTile buildLablelTile(BuildContext context, LabelUnit _label) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          Icons.label,
          color: _label.getColor(),
          size: 20,
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: Text(_label.title, softWrap: true, maxLines: 1,),
            )),
      ],
    ),
    onTap: () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NotesList(_label.id)),
          (Route<dynamic> route) => false);
    },
  );
}
