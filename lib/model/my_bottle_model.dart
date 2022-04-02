class MyBottle {
  int? id;
  String? information;
  int? isdelete;
  String? state;
  String? time;
  String? username;
  String? link;

  MyBottle(
      { required this.id,
        required this.information,
        required this.isdelete,
        required this.state,
        required this.time,
        required this.username,
        required this.link,
      }
        );

  MyBottle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    information = json['information'];
    isdelete = json['isdelete'];
    state = json['state'];
    time = json['time'];
    username = json['username'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['information'] = information;
    data['isdelete'] = isdelete;
    data['state'] = state;
    data['time'] = time;
    data['username'] = username;
    data['link'] = link;
    return data;
  }
}