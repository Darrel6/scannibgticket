import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:scanning_ticket/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class scanningService {
  static Future<Map<String, dynamic>> checkTicket(String reference) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = await pref.getString('token');
    Map bodyData = {"reference": reference};
    // encode Map to JSON
    var body = json.encode(bodyData);
    // log('body++++++++ $users_id');

    final response = await http.post(
      Uri.parse('$baseUrl/api/event-tickets/check'),
      headers: {
        "Content-Type": "application/json",
        "charset": 'utf-8',
        'Authorization': 'Bearer $token',
      },
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

  static Future<Map<String, dynamic>> validTicket(int ticket) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = await pref.getString('token');
    Map bodyData = {};
    // encode Map to JSON
    var body = json.encode(bodyData);
    // log('body++++++++ $users_id');

    final response = await http.post(
      Uri.parse('$baseUrl/api/event-tickets/$ticket/use'),
      headers: {
        "Content-Type": "application/json",
        "charset": 'utf-8',
        'Authorization': 'Bearer $token',
      },
      body: body,

      // You can add more headers or request data if necessary
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      // log(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw (jsonDecode(response.body)['message']);
    }
  }
}
