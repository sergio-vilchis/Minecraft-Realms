import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:minecraft_realms/models/world.dart';

import '../models/server.dart';

Future<Server> getWorlds(String token, String uhash) async {
  final Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'XBL3.0 x=$uhash;$token',
    HttpHeaders.acceptHeader: 'application/json',
    'RelyingParty': 'https://pocket.realms.minecraft.net/',
    'Client-Version':'1.19.31',
    HttpHeaders.contentTypeHeader: 'application/json'
  };
  final response = await http
      .get(Uri.parse('${dotenv.env['REALM_API_URL']}/worlds'), headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    World world =  World.fromJson(jsonDecode(response.body));
    return getWorld(world.servers[0].id, token, uhash);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load world');
  }
}

Future<Server> getWorld(int id, String token, String uhash) async {
  final Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'XBL3.0 x=$uhash;$token',
    HttpHeaders.acceptHeader: 'application/json',
    'RelyingParty': 'https://pocket.realms.minecraft.net/',
    'Client-Version':'1.19.31',
    HttpHeaders.contentTypeHeader: 'application/json'
  };
  final response = await http
      .get(Uri.parse('${dotenv.env['REALM_API_URL']}/worlds/$id'), headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Server.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load world');
  }
}

Future<String> activateSlot(int serverId, int slotId, String token, String uhash) async {
  debugPrint("Click");
  final Map<String, String> headers = {
    HttpHeaders.authorizationHeader: 'XBL3.0 x=$uhash;$token',
    HttpHeaders.acceptHeader: '*/*',
    'RelyingParty': 'https://pocket.realms.minecraft.net/',
    'Client-Version':'1.19.31',
    HttpHeaders.contentLengthHeader: '0'
  };
  final response = await http
      .put(Uri.parse('${dotenv.env['REALM_API_URL']}/worlds/$serverId/slot/$slotId'), headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load world');
  }
}