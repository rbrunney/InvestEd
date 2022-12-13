import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert';

class Requests {
  static Future<String> makePostRequest(
      String url, Map<String, dynamic> requestBody) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      'Accept': 'application/json'
    };
    Response response = await post(requestLink,
        headers: headers, body: json.encode(requestBody));

    return response.body;
  }

  static Future<String> makePostRequestWithAuth(String url, Map<String, dynamic> requestBody, String token) async {
    String jwtToken = "Bearer $token";
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: jwtToken,
    };
    Response response = await post(requestLink, headers: headers, body: json.encode(requestBody));

    return response.body;
  }

  static Future<String> makeGetRequest(String url) async {
    final requestLink = Uri.parse(url);
    Response response = await get(requestLink);

    return response.body;
  }

  static Future<String> makeGetRequestWithAuth(String url, String token) async {
    String jwtToken = "Bearer $token";
    final requestLink = Uri.parse(url);
    final headers = {HttpHeaders.authorizationHeader: jwtToken};

    Response response = await get(requestLink, headers: headers);

    return response.body;
  }

  static Future<String> makeDeleteRequest(String url, Map<String, dynamic> requestBody) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    Response response = await delete(requestLink,
        headers: headers, body: json.encode(requestBody));

    return response.body;
  }

  static Future<String> makeDeleteRequestWithAuth(String url, Map<String, dynamic> requestBody, String token) async {
    String jwtToken = "Bearer $token";
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: jwtToken
    };
    Response response = await delete(requestLink,
        headers: headers, body: json.encode(requestBody));

    return response.body;
  }

  static Future<String> makePutRequest(String url, Map<String, dynamic> requestBody) async {
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    Response response = await put(requestLink,
        headers: headers, body: json.encode(requestBody));

    return response.body;
  }

  static Future<String> makePutRequestWithAuth(String url, Map<String, dynamic> requestBody, String token) async {
    String jwtToken = "Bearer $token";
    final requestLink = Uri.parse(url);
    final headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: jwtToken
    };
    Response response = await put(requestLink,
        headers: headers, body: json.encode(requestBody));

    return response.body;
  }
}