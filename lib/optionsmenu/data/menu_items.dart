import 'package:flutter/material.dart';
import 'package:flutter_notes_app/optionsmenu/model/menu_item.dart';

class MenuItems {
  static const List<MenuItem> itemsFirst = [itemsSettings];
  static const List<MenuItem> itemsSecond = [itemsSignOut];

  static const itemsSettings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const itemsSignOut = MenuItem(text: 'Sign Out', icon: Icons.logout);
}
