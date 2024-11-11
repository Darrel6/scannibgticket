import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scanning_ticket/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class logAuth {
  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Map bodyData = {"email": email, "password": password};
    // encode Map to JSON
    var body = json.encode(bodyData);
    // log('body++++++++ $users_id');

    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {"Content-Type": "application/json", "charset": 'utf-8'},
      body: body,

      // You can add more headers or request data if necessary
    );

    if (response.statusCode == 200) {
      // log(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw (jsonDecode(response.body)['message']);
    }
  }

  static Future<Map<String, dynamic>> signout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Map bodyData = {"email": email, "password": password};
    // // encode Map to JSON
    // var body = json.encode(bodyData);
    // // log('body++++++++ $users_id');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/logout'),
      headers: {"Content-Type": "application/json", "charset": 'utf-8'},
      // body: body,

      // You can add more headers or request data if necessary
    );

    if (response.statusCode == 200) {
      // log(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw (jsonDecode(response.body)['message']);
    }
  }
}
