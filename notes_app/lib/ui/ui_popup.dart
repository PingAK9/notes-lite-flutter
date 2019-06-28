import 'package:flutter/material.dart';

Widget sortPopup(PopupMenuItemSelected<int> onSelected) => PopupMenuButton<int>(
  icon: Icon(
    Icons.sort,
    color: Colors.white,
  ),
  offset: new Offset(0, 40),
  padding: const EdgeInsets.all(0),
  onSelected: (value) {
    sortBy = value;
    if (value > 0) {
      onSelected(value);
    }
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      child: Text("Sort by"),
      value: 0,
    ),
    PopupMenuDivider(
      height: 10,
    ),
    CheckedPopupMenuItem(
      child: Text(
        "Color",
      ),
      value: 1,
      checked: sortBy == 1,
    ),
    CheckedPopupMenuItem(
      child: Text(
        "Modified time",
      ),
      value: 2,
      checked: sortBy == 2,
    ),
    CheckedPopupMenuItem(
      child: Text(
        "Created time",
      ),
      value: 3,
      checked: sortBy == 3,
    ),
  ],
);

Widget viewAsPopup(PopupMenuItemSelected<int> onSelected) => PopupMenuButton<int>(
  icon: Icon(
    Icons.view_comfy,
    color: Colors.white,
  ),
  offset: new Offset(0, 40),
  padding: const EdgeInsets.all(0),
  onSelected: (value) {
    if (value > 0) {
      viewAs = value;
      onSelected(value);
    }
  },
  itemBuilder: (context) => [
    PopupMenuItem(
      child: Text("View as"),
      value: 0,
    ),
    PopupMenuDivider(
      height: 10,
    ),
    CheckedPopupMenuItem(
      child: Text(
        "List",
      ),
      value: 1,
      checked: viewAs == 1,
    ),
    CheckedPopupMenuItem(
      child: Text(
        "Grid",
      ),
      value: 2,
      checked: viewAs == 2,
    ),
  ],
);


int viewAs = 1;
int sortBy = 1;

class ViewAs {
  static const int list = 1;
  static const int detail = 2;
}

class SortBy {
  static const int color = 1;
  static const int modified = 2;
  static const int created = 3;
}
