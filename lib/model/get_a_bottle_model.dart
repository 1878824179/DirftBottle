import 'dart:convert';

class GetABottle {
  GetABottle({
    required this.id,
    required this.information,
    required this.isdelete,
    required this.link,
    required this.state,
    required this.time,
    required this.username,
  });

  int? id;
  String? information;
  int? isdelete;
  String? link;
  String? state;
  String? time;
  String? username;

  factory GetABottle.fromJson(String str) =>
      GetABottle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetABottle.fromMap(Map<String, dynamic> json) => GetABottle(
        id: json["id"] == " " ? " " : json["id"],
        information: json["information"] == " " ? " " : json["information"],
        isdelete: json["isdelete"] == " " ? " " : json["isdelete"],
        link: json["link"] == " " ? " " : json["link"],
        state: json["state"] == " " ? " " : json["state"],
        time: json["time"] == " " ? " " : json["time"],
        username: json["username"] == " " ? " " : json["username"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "information": information ?? " ",
        "isdelete": isdelete ?? " ",
        "link": link ?? " ",
        "state": state ?? " ",
        "time": time ?? " ",
        "username": username ?? " ",
      };
}
