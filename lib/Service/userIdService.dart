import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart';
import '../Model/userIdModel.dart';

  Future<List<Uid>> getUserIds() async {
    var url = base_url + '/users/allId';
    var response = await http.get(url);
    var userIdsJson = json.decode(response.body);
    List<Uid> userIds = [];
    for (var userId in userIdsJson) {
      Uid u = Uid(id: userId['id']);
      userIds.add(u);
    }
    return userIds;
  }
