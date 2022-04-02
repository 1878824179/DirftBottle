import 'dart:convert';

class LoginModel {
  LoginModel({
    required this.sex,
    required this.state,
    required this.token,
    required this.username,
    required this.image,
    required this.address,
    required this.occupation,
  });

  String? sex;
  String? state;
  String? token;
  String? username;
  String? image;
  String? address;
  String? occupation;

  factory LoginModel.fromJson(String str) =>
      LoginModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
        sex: json["sex"] == " " ? " " : json["sex"],
        state: json["state"] == " " ? " " : json["state"],
        token: json["token"] == " " ? " " : json["token"],
        username: json["username"] == " " ? " " : json["username"],
        image: json["image"] == " " ? " " : json["image"],
        occupation: json["occupation"] == " " ? " " : json["occupation"],
        address: json["address"] == " " ? " " : json["address"],
      );

  Map<String, dynamic> toMap() => {
        "sex": sex ?? " ",
        "state": state ?? " ",
        "token": token ?? " ",
        "username": username ?? " ",
        "image": image ?? " ",
        "address": address ?? " ",
        "occupation": occupation ?? " ",
      };
}
