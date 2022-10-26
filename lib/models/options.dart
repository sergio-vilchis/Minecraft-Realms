class Options{
  final String slotName;
  final bool pvp;
  final bool spawnAnimals;
  final bool spawnMonsters;
  final bool spawnNPCs;
  final int spawnProtection;
  final bool commandBlocks;
  final bool forceGameMode;
  final int gameMode;
  final int difficulty;
  final String gameModeDescription;
  final int worldTemplateId;
  final String worldTemplateImage;
  final bool adventureMap;
  final bool cheatsAllowed;
  final bool texturePacksRequired;
  
  const Options({
    required this.slotName,
    required this.pvp,
    required this.spawnAnimals,
    required this.spawnMonsters,
    required this.spawnNPCs,
    required this.spawnProtection,
    required this.commandBlocks,
    required this.forceGameMode,
    required this.gameMode,
    required this.difficulty,
    required this.gameModeDescription,
    required this.worldTemplateId,
    required this.worldTemplateImage,
    required this.adventureMap,
    required this.cheatsAllowed,
    required this.texturePacksRequired
  });

  factory Options.fromJson(dynamic json){
    String gameModeDescription = "";
    switch (json['gameMode'] as int) {
      case 0:
        gameModeDescription="Survival";
        break;
      case 1:
        gameModeDescription="Creative";
        break;
      default:
        gameModeDescription="Template";
    }
    return Options(
      slotName: json['slotName'] as String,
      pvp: json['pvp'] as bool,
      spawnAnimals: json['spawnAnimals'] as bool,
      spawnMonsters: json['spawnMonsters'] as bool,
      spawnNPCs: json['spawnNPCs'] as bool,
      spawnProtection: json['spawnProtection'] as int,
      commandBlocks: json['commandBlocks'] as bool,
      forceGameMode: json['forceGameMode'] as bool,
      gameMode: json['gameMode'] as int,
      difficulty: json['difficulty'] as int,
      gameModeDescription: gameModeDescription,
      worldTemplateId: json['worldTemplateId'] as int,
      worldTemplateImage: json['worldTemplateImage'] as String,
      adventureMap: json['adventureMap'] as bool,
      cheatsAllowed: json['cheatsAllowed'] as bool,
      texturePacksRequired: json['texturePacksRequired'] as bool
      );
  }
}