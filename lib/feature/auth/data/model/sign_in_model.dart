
class SignInModel {
    String? access;
    String? refresh;
    int? deviceCount;
    Admin? admin;
    Avatarconfig? avatarconfig;
    String? heygenApiKey;

    SignInModel({this.access, this.refresh, this.deviceCount, this.admin, this.avatarconfig, this.heygenApiKey});

    SignInModel.fromJson(Map<String, dynamic> json) {
        access = json["access"];
        refresh = json["refresh"];
        deviceCount = json["device_count"];
        admin = json["admin"] == null ? null : Admin.fromJson(json["admin"]);
        avatarconfig = json["avatarconfig"] == null ? null : Avatarconfig.fromJson(json["avatarconfig"]);
        heygenApiKey = json["heygen_api_key"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["access"] = access;
        _data["refresh"] = refresh;
        _data["device_count"] = deviceCount;
        if(admin != null) {
            _data["admin"] = admin?.toJson();
        }
        if(avatarconfig != null) {
            _data["avatarconfig"] = avatarconfig?.toJson();
        }
        _data["heygen_api_key"] = heygenApiKey;
        return _data;
    }
}

class Avatarconfig {
    String? avatar_id;
    String? avatarName;
    String? avatarPreviewUrl;
    String? voiceUuidHeygen;
    String? context_id;

    Avatarconfig({this.avatar_id, this.avatarName, this.avatarPreviewUrl, this.voiceUuidHeygen, this.context_id});

    Avatarconfig.fromJson(Map<String, dynamic> json) {
        avatar_id = json["avatar_id"];
        avatarName = json["avatar_name"];
        avatarPreviewUrl = json["avatar_preview_url"];
        voiceUuidHeygen = json["voice_uuid_heygen"];
        context_id = json["context_id"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["avatar_id"] = avatar_id;
        _data["avatar_name"] = avatarName;
        _data["avatar_preview_url"] = avatarPreviewUrl;
        _data["voice_uuid_heygen"] = voiceUuidHeygen;
        _data["context_id"] = context_id;
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