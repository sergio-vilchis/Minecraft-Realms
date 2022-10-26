import 'package:minecraft_realms/models/server.dart';

class World{
  final List<Server> servers;
  const World({
    required this.servers,
  });

  factory World.fromJson(Map<String, dynamic> json){
    var serverObjList = json['servers'] as List;
    List<Server> serverList = serverObjList.map((serverJson) => Server.fromJson(serverJson)).toList();
    return World(servers: serverList);
  }
}