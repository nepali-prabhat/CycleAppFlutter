import 'dart:convert';

List<LocationGet> locationGetFromJson(String str) => new List<LocationGet>.from(json.decode(str).map((x) => LocationGet.fromJson(x)));

String locationGetToJson(List<LocationGet> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class LocationGet {
    LUser user;
    double long;
    double lat;

    LocationGet({
        this.user,
        this.long,
        this.lat,
    });

    factory LocationGet.fromJson(Map<String, dynamic> json) => new LocationGet(
        user: json["user"] == null ? null : LUser.fromJson(json["user"]),
        long: json["long"] == null ? null : json["long"].toDouble(),
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
        "long": long == null ? null : long,
        "lat": lat == null ? null : lat,
    };
}

class LUser {
    int id;
    String fName;
    String lName;
    String phone;

    LUser({
        this.id,
        this.fName,
        this.lName,
        this.phone,
    });

    factory LUser.fromJson(Map<String, dynamic> json) => new LUser(
        id: json["id"] == null ? null : json["id"],
        fName: json["f_name"] == null ? null : json["f_name"],
        lName: json["l_name"] == null ? null : json["l_name"],
        phone: json["phone"] == null ? null : json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "f_name": fName == null ? null : fName,
        "l_name": lName == null ? null : lName,
        "phone": phone == null ? null : phone,
    };
}
