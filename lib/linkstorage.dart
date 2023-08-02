import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'linkitem.dart';

class LinkStorage {
  static const String _storageKey = 'link_items';

  Future<List<LinkItem>> getStoredItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<LinkItem> items = jsonList.map((jsonItem) {
        return LinkItem(
          name: jsonItem['name'],
          urlLink: jsonItem['urlLink'],
        );
      }).toList();
      return items;
    } else {
      return [];
    }
  }

  Future<void> saveItems(List<LinkItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList = items.map((item) {
      return item.toJSONEncodable();
    }).toList();
    String jsonString = jsonEncode(jsonList);
    prefs.setString(_storageKey, jsonString);
  }
}
