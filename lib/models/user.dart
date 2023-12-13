class User {
  static const String nameKey = "user_name";
  static const String dataArrayKey = "user_data_array";
  List? dataArray;
  String? userName;

  User({this.userName, this.dataArray});

  factory User.fromJson(Map<dynamic, dynamic> json) => User(
        userName: json[nameKey],
        dataArray: json[dataArrayKey],
      );

  Map<String, dynamic> toJson() => {
        nameKey: userName,
        dataArrayKey: dataArray,
      };
  static User fromMap(Map<String, dynamic> user) {
    return new User(
      userName: user[nameKey],
      dataArray: (user[dataArrayKey]),
    );
  }

  toMap() {
    return {
      'user': userName,
      'password': dataArrayKey,
    };
  }
}
