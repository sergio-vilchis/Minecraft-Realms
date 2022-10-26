import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_realms/services/realm_services.dart';

class XUI {
  final String uhs;

  const XUI({required this.uhs});

  factory XUI.fromJson(dynamic json) {
    return XUI(uhs: json['uhs'] as String);
  }
}

class DisplayClaimsResponse {
  final List<XUI> xui;

  const DisplayClaimsResponse({required this.xui});

  factory DisplayClaimsResponse.fromJson(dynamic json) {
    var xuiObjList = json['xui'] as List;
    List<XUI> xuiList = xuiObjList.map((xuiJson) => XUI.fromJson(xuiJson)).toList();
    return DisplayClaimsResponse(xui: xuiList);
  }
}

class XBoxAuthResponse {
  final String IssueInstant;
  final String NotAfter;
  final String Token;
  final DisplayClaimsResponse DisplayClaims;

  const XBoxAuthResponse(
      {required this.IssueInstant,
      required this.NotAfter,
      required this.Token,
      required this.DisplayClaims
      });

  factory XBoxAuthResponse.fromJson(dynamic json) {
    return XBoxAuthResponse(
        IssueInstant: json['IssueInstant'] as String,
        NotAfter: json['NotAfter'] as String,
        Token: json['Token'] as String,
        DisplayClaims: DisplayClaimsResponse.fromJson(json['DisplayClaims'])
    );
  }
}

Future<void> xboxAuth(String accessToken) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  final body = {
    "Properties": {
      "AuthMethod": "RPS",
      "SiteName": "user.auth.xboxlive.com",
      "RpsTicket":
          "d=$accessToken" // your access token from the previous step here
    },
    "RelyingParty": "http://auth.xboxlive.com",
    "TokenType": "JWT"
  };
  final response = await http.post(
      Uri.parse('${dotenv.env['XBOX_LIVE_URL']}/user/authenticate'),
      headers: headers,
      body: jsonEncode(body));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    XBoxAuthResponse authResponse = XBoxAuthResponse.fromJson(jsonDecode(response.body));
    xboxXSTS(authResponse.Token, authResponse.DisplayClaims.xui[0].uhs);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    debugPrint(response.body);
    throw Exception('Failed to load worlds');
  }
}

Future<void> xboxXSTS(String token, String userHash) async {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };
  final body = {
    "Properties": {
      "SandboxId": "RETAIL",
      "UserTokens": ["$token"]
    },
    "RelyingParty": "https://pocket.realms.minecraft.net/",
    "TokenType": "JWT"
  };
  final response = await http.post(
      Uri.parse('${dotenv.env['XBOX_LIVE_XSTS_URL']}/xsts/authorize'),
      headers: headers,
      body: jsonEncode(body));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    XBoxAuthResponse authResponse = XBoxAuthResponse.fromJson(jsonDecode(response.body));
    document.cookie="Token=${authResponse.Token}";
    document.cookie="UHS=${authResponse.DisplayClaims.xui[0].uhs}";
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
  }
}
Map<String, String> headers = {};
void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie']!;
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

