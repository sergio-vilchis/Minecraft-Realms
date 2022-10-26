import 'package:minecraft_realms/models/Slot.dart';
import 'package:minecraft_realms/models/player.dart';

class Server{

  final int id;
  final String remoteSubscriptionId;
  final String owner;
  final String ownerUUID;
  final String name;
  final String motd;
  final String defaultPermission;
  final String state;
  final int daysLeft;
  final bool expired;
  final bool expiredTrial;
  final bool gracePeriod;
  final String worldType;
  final List<Player> players;
  final int maxPlayers;
  final int activeSlot;
  final List<Slot> slots;
  final bool member;
  final int clubId;

  const Server({
    required this.id,
    required this.remoteSubscriptionId,
    required this.owner,
    required this.ownerUUID,
    required this.name,
    required this.motd,
    required this.defaultPermission,
    required this.state,
    required this.daysLeft,
    required this.expired,
    required this.expiredTrial,
    required this.gracePeriod,
    required this.worldType,
    required this.players,
    required this.maxPlayers,
    required this.activeSlot,
    required this.slots,
    required this.member,
    required this.clubId
  });

  factory Server.fromJson(Map<String, dynamic> json){
    var playerObjList = (json['players'] ?? []) as List;
    List<Player> playerList = playerObjList.map((playerJson) => Player.fromJson(playerJson)).toList();
    var slotObjList = (json['slots'] ?? []) as List;
    List<Slot> slotList = slotObjList.map((slotJson) => Slot.fromJson(slotJson)).toList();
    return Server(
      id: json['id'],
      remoteSubscriptionId: json['remoteSubscriptionId'],
      owner: json['owner'] ?? '',
      ownerUUID: json['ownerUUID'],
      name: json['name'],
      motd: json['motd'],
      defaultPermission: json['defaultPermission'],
      state: json['state'],
      daysLeft: json['daysLeft'],
      expired: json['expired'],
      expiredTrial: json['expiredTrial'],
      gracePeriod: json['gracePeriod'],
      worldType: json['worldType'],
      players: playerList,
      maxPlayers: json['maxPlayers'],
      activeSlot: json['activeSlot'],
      slots: slotList,
      member: json['member'],
      clubId: json['clubId']
    );
  }
}