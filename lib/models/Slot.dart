import 'dart:convert';

import 'options.dart';

class Slot{
   final String options;
   final int slotId;

   const Slot({
    required this.options,
    required this.slotId
   });

   factory Slot.fromJson(Map<String, dynamic> json){
    return Slot(
        options: json['options'], 
        slotId: json['slotId']
      );
   }
}