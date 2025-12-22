
class SignInModel {
    String? access;
    String? refresh;
    int? deviceCount;
    Admin? admin;

    SignInModel({this.access, this.refresh, this.deviceCount, this.admin});

    SignInModel.fromJson(Map<String, dynamic> json) {
        access = json["access"];
        refresh = json["refresh"];
        deviceCount = json["device_count"];
        admin = json["admin"] == null ? null : Admin.fromJson(json["admin"]);
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["access"] = access;
        _data["refresh"] = refresh;
        _data["device_count"] = deviceCount;
        if(admin != null) {
            _data["admin"] = admin?.toJson();
        }
        return _data;
    }
}

class Admin {
    int? id;
    String? fullName;
    String? email;
    int? business;

    Admin({this.id, this.fullName, this.email, this.business});

    Admin.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        fullName = json["full_name"];
        email = json["email"];
        business = json["business"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["full_name"] = fullName;
        _data["email"] = email;
        _data["business"] = business;
        return _data;
    }
}