
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
    String? avatarId;
    String? avatarName;
    String? avatarPreviewUrl;
    String? contextId;
    String? voiceId;

    Avatarconfig({this.avatarId, this.avatarName, this.avatarPreviewUrl, this.contextId, this.voiceId});

    Avatarconfig.fromJson(Map<String, dynamic> json) {
        avatarId = json["avatar_id"];
        avatarName = json["avatar_name"];
        avatarPreviewUrl = json["avatar_preview_url"];
        contextId = json["context_id"];
        voiceId = json["voice_id"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["avatar_id"] = avatarId;
        _data["avatar_name"] = avatarName;
        _data["avatar_preview_url"] = avatarPreviewUrl;
        _data["context_id"] = contextId;
        _data["voice_id"] = voiceId;
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