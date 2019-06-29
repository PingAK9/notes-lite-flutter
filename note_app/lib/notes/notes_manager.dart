import 'package:flutter/material.dart';
import 'package:note_app/datas/notes_datas.dart';
import 'package:note_app/ui/ui_popup.dart';

class NotesManager extends StatefulWidget {
  @override
  _NotesManager createState() => _NotesManager();

  List<NoteUnit> _noteDatas;

  NotesManager(List<NoteUnit> notes) {
    _noteDatas = notes;
  }
}

class _NotesManager extends State<NotesManager> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    count = 1;
  }

  void sortData() {
    switch (sortBy) {
      case SortBy.color:
        widget._noteDatas.sort((a, b) => a.idLabel.compareTo(b.idLabel));
        break;
      case SortBy.created:
        widget._noteDatas
            .sort((b, a) => a.dateCreated.compareTo(b.dateCreated));
        break;
      case SortBy.modified:
        widget._noteDatas
            .sort((b, a) => a.dateModified.compareTo(b.dateModified));
        break;
    }
  }

  int count = 0;

  void updateCount(NoteUnit note) {
    if (note != null) {
      note.select = !note.select;
    }
    count = 0;
    for (int i = 0; i < widget._noteDatas.length; i++) {
      if (widget._noteDatas[i].select) {
        count++;
      }
    }
  }

  void selectAll(bool _value) {
    for (int i = 0; i < widget._noteDatas.length; i++) {
      widget._noteDatas[i].select = _value;
    }
    count = _value ? widget._noteDatas.length : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      new AppBar(iconTheme: IconThemeData(color: Colors.white), actions: [
        Container(
          alignment: AlignmentDirectional.center,
          child: Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        IconButton(
          icon: Icon(count == widget._noteDatas.length
              ? Icons.check_box
              : Icons.check_box_outline_blank),
          onPressed: () {
            setState(() {
              selectAll(count != widget._noteDatas.length);
            });
          },
        ),
        deletePopup(Colors.white, (value) {
          if (value == 1) {
            for (int i = (widget._noteDatas.length - 1); i >= 0; i--) {
              if (widget._noteDatas[i].select) {
                removeNote(widget._noteDatas[i].id);
                widget._noteDatas.removeAt(i);
              }
            }
            updateCount(null);
            setState(() {});
          }
        }),
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
    );
  }

  Widget buildContent() {
    if (viewAs == ViewAs.list) {
      return Container(
        child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: widget._noteDatas.length,
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
    for (int i = 0; i < widget._noteDatas.length; i++) {
      list.add(buidNoteItem(i, height));
    }
    return list;
  }

  Widget buidNoteItem(int index, double height) {
    NoteUnit note = widget._noteDatas[index];
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
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: <Widget>[
                          buildNoteTitle(index),
                          Container(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                deletePopup(Colors.black87, (value) {
                                  if (value == 1) {
                                    setState(() {
                                      removeNote(note.id);
                                      widget._noteDatas.removeWhere(
                                              (item) => item.id == note.id);
                                      updateCount(null);
                                    });
                                  }
                                }),
                                Icon(
                                  note.select
                                      ? Icons.check_circle_outline
                                      : Icons.radio_button_unchecked,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            updateCount(note);
          });
        },
      ),
    );
  }

  Widget buildNoteTitle(int index) {
    NoteUnit note = widget._noteDatas[index];
    if (note.type == NoteType.Checklist) {
      return Container(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
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
                softWrap: true,
                maxLines: 2,
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          note.getTitle(),
          softWrap: true,
          maxLines: 2,
        ),
      );
    }
  }

  Widget deletePopup(Color color, PopupMenuItemSelected<int> onSelect) =>
      PopupMenuButton<int>(
        icon: Icon(
          Icons.restore_from_trash,
          color: color,
        ),
        offset: new Offset(0, 40),
        padding: const EdgeInsets.all(0),
        onSelected: onSelect,
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Delete note"),
            value: 1,
          ),
          PopupMenuDivider(
            height: 10,
          ),
          PopupMenuItem(
            child: Text(
              "Cancel",
            ),
            value: 0,
          ),
        ],
      );
}
