import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_notes_app/datas/notes_datas.dart';
import 'package:flutter_notes_app/ui/ui_drawer.dart';

class EditNote extends StatefulWidget {
  @override
  _EditNoteState createState() => _EditNoteState();
  NoteUnit noteUnit;

  EditNote(NoteUnit note) {
    noteUnit = note;
    if (noteUnit == null) {
      noteUnit = new NoteUnit(
          id: -1,
          type: NoteType.Text,
          title: '',
          content: '',
          idLabel: -1,
          dateCreated: DateTime.now(),
          dateModified: DateTime.now());
    }
  }
}

class _EditNoteState extends State<EditNote> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    txtTitle.text = widget.noteUnit.title;
    if (widget.noteUnit.type == NoteType.Text) {
      txtContent.text = widget.noteUnit.content;
    } else {
      List<String> listContent = widget.noteUnit.content.split('\n');
      txtContentList = new List();
      for (int i = 0; i < listContent.length; i++) {
        txtContentList.add(new TextEditingController());
        txtContentList[i].text = listContent[i];
      }
    }
  }

  Color getLabelColor()
  {
    for (int i = 0; i < labelDatas.length; i++) {
      if (labelDatas[i].id == widget.noteUnit.idLabel) {
        return labelDatas[i].getFadeColor();
      }
    }
   return Colors.grey[200];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        drawer: buildDrawer(context),
        appBar: new AppBar(
            backgroundColor: getLabelColor(),
            iconTheme: IconThemeData(color: Colors.black87),
            title: TextField(
              controller: txtTitle,
              style: new TextStyle(
                color: Colors.black87,

              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                  hintText: 'Input title'),
              keyboardType: TextInputType.text,
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    // save
                    saveNote();
                  }),
              IconButton(
                  icon: Icon(
                    widget.noteUnit.type == NoteType.Checklist
                        ? Icons.wrap_text
                        : Icons.check_box,),
                  onPressed: () {
                    changeType();
                    // save
                  }),
            ]),
        body: Column(
          children: <Widget>[
            buildLabel(),
            Expanded(child: buidBody()),
          ],
        ));
  }

  Widget buildLabel() {
    return Container(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: labelDatas.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buidLabelButton(index),
            );
          }),
    );
  }

  Widget buidLabelButton(int index) {
    if (labelDatas[index].id == widget.noteUnit.idLabel) {
      return RaisedButton(
        color: labelDatas[index].getColor(),
        child: Container(child: Text(labelDatas[index].title)),
        onPressed: () {
          setState(() {
            widget.noteUnit.idLabel = -1;
          });
        },
      );
    } else {
      return RaisedButton(
        child: Text(labelDatas[index].title),
        onPressed: () {
          setState(() {
            widget.noteUnit.idLabel = labelDatas[index].id;
          });
        },
      );
    }
  }

  var txtTitle = new TextEditingController();
  var txtContent = new TextEditingController();
  var txtContentList = new List<TextEditingController>();

  changeType() {
    if (widget.noteUnit.type == NoteType.Checklist) {
      widget.noteUnit.type = NoteType.Text;
      txtContent.text = listToString(txtContentList);
    } else {
      widget.noteUnit.type = NoteType.Checklist;
      List<String> contents = txtContent.text.split('\n');
      txtContentList = new List();
      for (int i = 0; i < contents.length; i++) {
        txtContentList.add(new TextEditingController());
        txtContentList[i].text = contents[i];
      }
    }
    setState(() {});
  }

  String listToString(List<TextEditingController> list) {
    String value = '';
    for (int i = 0; i < list.length; i++) {
      value += list[i].text;
      if (i < (list.length - 1)) value += '\n';
    }
    return value;
  }

  saveNote() {
    if (noteIsNoteEmpty()) {
      widget.noteUnit.title = txtTitle.text;
      if (widget.noteUnit.type == NoteType.Checklist) {
        widget.noteUnit.content = listToString(txtContentList);
      } else {
        widget.noteUnit.content = txtContent.text;
      }
      addNewNote(widget.noteUnit);
    }
    Navigator.pop(context, true);
  }

  bool noteIsNoteEmpty() {
    if (txtTitle.text.isNotEmpty) {
      return true;
    } else {
      if (widget.noteUnit.type == NoteType.Text) {
        return txtContent.text.isNotEmpty;
      } else {
        return txtContentList.length > 0;
      }
    }
  }

  Widget buidBody() {
    if (widget.noteUnit.type == NoteType.Text)
      return buidBodyText();
    else
      return buidBodyChecklist();
  }

  Widget buidBodyText() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: txtContent,
        decoration: InputDecoration(border: InputBorder.none, hintText: '...'),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }

  var checkbox = new List<TextEditingController>();

  Widget buidBodyChecklist() {
    return Container(
        width: double.infinity,
        child: ListView.builder(
            itemCount: txtContentList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == txtContentList.length)
                return buildAddItem();
              else
                return buidCheckBox(index);
            }));
  }

  Widget buidCheckBox(int index) {
    return Container(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.check_box_outline_blank), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: txtContentList[index],
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: ''),
              keyboardType: TextInputType.text,
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () {
                txtContentList.removeAt(index);
                setState(() {});
                // save
              }),
        ],
      ),
    );
  }

  Widget buildAddItem() {
    return Container(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.add_circle_outline),
            Text('  Add Item')
          ],
        ),
        onPressed: () {
          txtContentList.add(new TextEditingController());
          setState(() {});
        },
      ),
    );
  }
}
