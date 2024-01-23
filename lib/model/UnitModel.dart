import 'dart:convert';

UnitModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return UnitModel.fromMap(jsonData);
}

String clientToJson(UnitModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class UnitModel {
  late int id;
  late String name;

  UnitModel(){
    id = 0;
    name = "";
  }

  UnitModel.fromMap(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}
