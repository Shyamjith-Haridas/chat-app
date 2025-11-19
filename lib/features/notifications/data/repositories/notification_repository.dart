import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  final String baseUrl;

  NotificationRepository({required this.baseUrl});

  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse('$baseUrl/send-notification');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token, "title": title, "body": body}),
    );

    debugPrint("Notification response: ${response.body}");
  }
}
