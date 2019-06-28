import 'package:flutter/material.dart';
import 'package:flutter_notes_app/ui/ui_drawer.dart';
import 'package:flutter_notes_app/datas/notes_datas.dart';
import 'package:flutter_notes_app/notes/notes_manager.dart';
import 'package:flutter_notes_app/ui/ui_popup.dart';
import 'edit_note.dart';

class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
  int idLabel;

  NotesList(int id) {
    idLabel = id;
  }
}

class _NotesListState extends State<NotesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = "Notes";
    _noteDatas = new List();
    _loadNoteData();
    _loadLabelData();
  }

  List<NoteUnit> _noteDatas;

  void _loadNoteData() {
    loadNoteData().then((value) {
      if (widget.idLabel > 0) {
        _noteDatas =
            noteDatas.where((item) => item.idLabel == widget.idLabel).toList();
      } else {
        _noteDatas = noteDatas;
      }
      setState(() {
        sortData();
      });
    });
  }

  void _loadLabelData() {
    loadLabelData().then((value) {
      if (widget.idLabel > 0) {
        LabelUnit _label =
            value.singleWhere((item) => item.id == widget.idLabel);
        if (_label != null) {
          title = _label.title;
        }
      } else {
        title = "All Notes";
      }
      setState(() {});
    });
  }

  void sortData() {
    switch (sortBy) {
      case SortBy.color:
        _noteDatas.sort((a, b) => a.idLabel.compareTo(b.idLabel));
        break;
      case SortBy.created:
        _noteDatas.sort((b, a) => a.dateCreated.compareTo(b.dateCreated));
        break;
      case SortBy.modified:
        _noteDatas.sort((b, a) => a.dateModified.compareTo(b.dateModified));
        break;
    }
  }

  String title = "Notes";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: new Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.library_add),
              onPressed: goToAddNote,
            ),
            viewAsPopup((index) {
              setState(() {});
            }),
            sortPopup((index) {
              setState(() {
                sortData();
              });
            }),
          ]),
      body: buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddNote,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void goToAddNote() {
    NoteUnit noteUnit = new NoteUnit(
        id: -1,
        type: NoteType.Text,
        title: '',
        content: '',
        idLabel: widget.idLabel);
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditNote(noteUnit)))
        .then((value) {
      _loadNoteData();
    });
  }

  Widget buildContent() {
    if (viewAs == ViewAs.list) {
      return Container(
        child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _noteDatas.length,
            itemBuilder: (BuildContext context, int index) {
              return buidNoteItem(index, 85);
            }),
      );
    } else {
      var size = MediaQuery.of(context).size;

      final double itemHeight = 100;
      final double itemWidth = size.width / 2;
      return Container(
          padding: EdgeInsets.all(8),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: (itemWidth / itemHeight),
            children: listNoteItem(itemHeight),
          ));
    }
  }

  List<Widget> listNoteItem(double height) {
    List<Widget> list = new List();
    for (int i = 0; i < _noteDatas.length; i++) {
      list.add(buidNoteItem(i, height));
    }
    return list;
  }

  Widget buidNoteItem(int index, double height) {
    NoteUnit note = _noteDatas[index];
    LabelUnit _label = getLabel(note.idLabel);
    return Container(
      height: height,
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Container(
              height: 8,
              color: _label.getColor(),
            ),
            Container(
              width: double.infinity,
              height: height - 15,
              color: _label.getFadeColor(),
              padding: EdgeInsets.fromLTRB(8, 8, 8, 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(NoteUnit.dateToString(note.dateCreated),
                      softWrap: false,
                      style: Theme.of(context).textTheme.overline),
                  Container(
                      height: height - 25 - 13,
                      alignment: AlignmentDirectional.centerStart,
                      child: buildNoteTitle(index)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditNote(note)))
              .then((value) {
            _loadNoteData();
          });
        },
        onLongPress: () {
          for (int i = 0; i < _noteDatas.length; i++) {
            _noteDatas[i].select = index == i;
          }
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotesManager(_noteDatas)))
              .then((value) {
            _loadNoteData();
          });
        },
      ),
    );
  }

  Widget buildNoteTitle(int index) {
    NoteUnit note = _noteDatas[index];
    if (note.type == NoteType.Checklist) {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: Icon(
              Icons.check_box_outline_blank,
            ),
          ),
          Expanded(
            child: Text(
              note.getTitle(),
              textAlign: TextAlign.left,
              softWrap: true,
              maxLines: 2,
            ),
          )
        ],
      );
    } else {
      return Text(
        note.getTitle(),
        softWrap: true,
        maxLines: 2,
      );
    }
  }
}
