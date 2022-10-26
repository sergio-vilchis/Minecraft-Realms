class Player{
  final String uuid;
  final bool operator;
  final bool accepted;
  final bool online;
  final String permission;

  const Player({
    required this.uuid,
    required this.operator,
    required this.accepted,
    required this.online,
    required this.permission
  });

  factory Player.fromJson(Map<String, dynamic> json){
    return Player(
        uuid: json['uuid'],
        operator: json['operator'],
        accepted: json['accepted'],
        online: json['online'],
        permission: json['permission']
      );
  }
}