import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

LabelUnit labelDefault =
    new LabelUnit(id: -1, title: 'Default', a: 255, r: 111, g: 150, b: 153);
List<LabelUnit> labelDatas;
List<NoteUnit> noteDatas;

Future<List<LabelUnit>> loadLabelData() async {
  if (labelDatas == null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('key_label_data');
    if (response != null) {
      var list = json.decode(response) as List;
      labelDatas = list.map((item) => LabelUnit.fromJson(item)).toList();
    } else {
      labelDatas = [
        new LabelUnit(id: 1, title: 'Home', a: 255, r: 0, g: 191, b: 255),
        new LabelUnit(id: 2, title: 'Work', a: 255, r: 255, g: 153, b: 0),
        new LabelUnit(id: 3, title: 'Other', a: 255, r: 111, g: 150, b: 153)
      ];
      saveLabelData();
    }
  }
  return labelDatas;
}

addNewLabel(String title) {
  int id = 1;
  if (labelDatas.length > 0) id = labelDatas[labelDatas.length - 1].id + 1;
  labelDatas.add(new LabelUnit(id: id, title: title));
  saveLabelData();
}

updateLabel(LabelUnit _label) {
  for (int i = 0; i < labelDatas.length; i++) {
    if (_label.id == labelDatas[i].id) labelDatas[i] = _label;
  }
  saveLabelData();
}

removeLabel(int _id) {
  labelDatas.removeWhere((item) => item.id == _id);
  for (int i = 0; i < noteDatas.length; i++) {
    if (noteDatas[i].id == _id) {
      noteDatas[i].idLabel = -1;
    }
  }
  saveLabelData();
  saveNoteData();
}

saveLabelData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var myJsonString =
      json.encode(labelDatas.map((value) => value.toMap()).toList());
  prefs.setString('key_label_data', myJsonString);
}

getLabel(int _id) {
  for (int i = 0; i < labelDatas.length; i++) {
    if (labelDatas[i].id == _id) {
      return labelDatas[i];
    }
  }
  // return default
  return labelDefault;
}

Future<List<NoteUnit>> loadNoteData() async {
  noteDatas = null;
  if (noteDatas == null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String response = prefs.getString('key_note_data');
    if (response != null) {
      var list = json.decode(response) as List;
      noteDatas = list.map((item) => NoteUnit.fromJson(item)).toList();
    } else {
      noteDatas = new List();
      saveNoteData();
    }
  }
  return noteDatas;
}

saveNoteData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var myJsonString =
      json.encode(noteDatas.map((value) => value.toMap()).toList());
  prefs.setString('key_note_data', myJsonString);
}

addNewNote(NoteUnit note) {
  if (note.id > 0) {
    note.dateModified = DateTime.now();
    for (int i = 0; i < noteDatas.length; i++) {
      if (noteDatas[i].id == note.id) {
        noteDatas[i] = note;
        break;
      }
    }
  } else {
    note.dateModified = DateTime.now();
    note.dateCreated = DateTime.now();
    note.id = note.dateCreated.millisecondsSinceEpoch;

    noteDatas.add(note);
  }
  saveNoteData();
}

removeNote(int _id) {
  noteDatas.removeWhere((item) => item.id == _id);
  saveNoteData();
}

class NoteUnit {
  int id;
  String type;
  String title;
  String content;
  int idLabel;
  DateTime dateCreated;
  DateTime dateModified;
  bool select;

  NoteUnit(
      {this.id,
      this.title,
      this.type,
      this.content,
      this.idLabel,
      this.dateCreated,
      this.dateModified});

  String getTitle() {
    int max = 50;
    if (title.isNotEmpty)
      return title.substring(0, title.length > max ? max : title.length);
    else {
      if (type == NoteType.Checklist) {
        return content.substring(0, content.length > max ? max : content.length);
      } else {
        return content.substring(0, content.length > max ? max : content.length);
      }
    }
  }

  factory NoteUnit.fromJson(Map<String, dynamic> json) {
    return NoteUnit(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      content: json['content'],
      idLabel: json['idLabel'],
      dateCreated: stringToDate(json['dateCreated'].toString()),
      dateModified: stringToDate(json['dateModified'].toString()),
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["type"] = type;
    map["content"] = content;
    map["idLabel"] = idLabel;
    map["dateCreated"] = dateToString(dateCreated);
    map["dateModified"] = dateToString(dateModified);

    return map;
  }

  static DateTime stringToDate(String dateString) {
    if (dateString == null) {
      return DateTime.now();
    } else {
      try {
        return DateTime.parse(dateString);
      } catch (exception) {
        return DateTime.now();
      }
    }
  }

  static String dateToString(DateTime date) {
    // 2012-02-27 13:27:00
    if (date == null) {
      date = DateTime.now();
    }
    String _value = '${date.year.toString()}' +
        '-${date.month.toString().padLeft(2, '0')}' +
        '-${date.day.toString().padLeft(2, '0')}' +
        ' ${date.hour.toString().padLeft(2, '0')}' +
        ':${date.minute.toString().padLeft(2, '0')}' +
        ':${date.second.toString().padLeft(2, '0')}';
    return _value;
  }
}

class NoteType {
  static const Text = 'text';
  static const Checklist = 'checklist';
}

class LabelUnit {
  int id;
  String title;
  int a;
  int r;
  int g;
  int b;

  Color getColor() {
    if (a == null) {
      r = 0;
      g = 191;
      b = 255;
      a = 255;
    }
    return new Color.fromARGB(a, r, g, b);
  }

  setColor(Color color) {
    r = color.red;
    g = color.green;
    b = color.blue;
    a = color.alpha;
  }

  Color getFadeColor() {
    Color newColor = getColor();
    int newAlpha = (newColor.alpha * 0.4).round();
    return newColor.withAlpha(newAlpha);
  }

  LabelUnit({this.id, this.title, this.a, this.r, this.g, this.b});

  factory LabelUnit.fromJson(Map<String, dynamic> json) {
    return LabelUnit(
      id: json['id'],
      title: json['title'],
      a: json['a'],
      r: json['r'],
      g: json['g'],
      b: json['b'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["a"] = a;
    map["r"] = r;
    map["g"] = g;
    map["b"] = b;
    return map;
  }
}
