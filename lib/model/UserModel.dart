import 'dart:convert';

UserModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return UserModel.fromMap(jsonData);
}

String clientToJson(UserModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class UserModel {
  late int id;
  late int identityNumber;
  late String nameSurname;
  late String phone;
  late String eMail;
  late bool isDeleted;

  UserModel(){
  id = 0;
  identityNumber = 0;
  nameSurname = "";
  phone = "";
  eMail = "";
  isDeleted = false;
}

  UserModel.fromMap(Map<String, dynamic> json) {
    id = json["id"];
    identityNumber = json["identityNumber"];
    nameSurname = json["nameSurname"];
    phone = json["phone"];
    eMail = json["eMail"];
    isDeleted = json["isDeleted"] == 1;
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "identityNumber": identityNumber,
    "nameSurname": nameSurname,
    "phone": phone,
    "eMail": eMail,
    "isDeleted": isDeleted,
  };
}
