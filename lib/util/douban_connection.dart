import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:douban_game_flutter/util/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart' as config;
import 'exception.dart';

class DoubanConnection {
  static final DoubanConnection _instance = DoubanConnection._internal();

  factory DoubanConnection() {
    return _instance;
  }

  DoubanConnection._internal();

  final _BASE_HOST = config.API_HOST;

  var _accessToken = '';
  var _userId = '';

  // Is There a userID yet?
  bool get isLogin => _userId.isNotEmpty;

  var _POST_HEADERS = {
    HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
  };

  Future<void> init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _userId = sharedPreferences.getString(PREFS_KEY['userId']) ?? '';
  }

  Future<dynamic> _baseGetApi(Uri uri, Map<String, String> headers) async {
    try {
      final response = await http.get(uri, headers: headers);
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> _basePostApi(
      Uri uri, Map<String, String> body, Map<String, String> headers) async {
    try {
      final response = await http.post(uri, headers: headers, body: body);
      final responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
      case 401:
      case 403:
      case 404:
        throw BadRequestException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Uri _apiUriBuilder(String uri, {Map<String, String> param}) {
    return Uri.https(_BASE_HOST, uri, param);
  }

  Map<String, String> _legitHeaderBuilder() {
    return {
      HttpHeaders.authorizationHeader: 'Bearer ' + _accessToken,
      HttpHeaders.userAgentHeader: config.USER_AGENT,
    };
  }

  Future<dynamic> login(String username, String password) async {
    final loginBody = {
      'client_id': config.CLIENT_ID,
      'client_secret': config.CLIENT_SECRET,
      'redirect_uri': config.REDIRECT_URI,
      'grant_type': config.GRANT_TYPE,
      'username': username,
      'password': password,
    };
    final headers = {
      ..._POST_HEADERS,
    };
    final uri = _apiUriBuilder('/service/auth2/token');
    final response = await _basePostApi(uri, loginBody, headers);
    return response;
  }
}
