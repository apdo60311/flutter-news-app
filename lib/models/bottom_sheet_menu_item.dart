import 'package:flutter/material.dart';

class BottomSheetMenuItem {
  final String itemName;
  final IconData itemIcon;
  final func;
  BottomSheetMenuItem({
    required this.itemName,
    required this.itemIcon,
    required this.func,
  });
}
