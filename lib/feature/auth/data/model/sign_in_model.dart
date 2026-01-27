
class SignInModel {
    String? access;
    String? refresh;
    int? deviceCount;
    Admin? admin;
    Business? business;
    String? businessLogo;
    Avatarconfig? avatarconfig;
    String? heygenApiKey;

    SignInModel({this.access, this.refresh, this.deviceCount, this.admin, this.business, this.businessLogo, this.avatarconfig, this.heygenApiKey});

    SignInModel.fromJson(Map<String, dynamic> json) {
        access = json["access"];
        refresh = json["refresh"];
        deviceCount = json["device_count"];
        admin = json["admin"] == null ? null : Admin.fromJson(json["admin"]);
        business = json["business"] == null ? null : Business.fromJson(json["business"]);
        businessLogo = json["business_logo"];
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
        if(business != null) {
            _data["business"] = business?.toJson();
        }
        _data["business_logo"] = businessLogo;
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

class Business {
    int? id;
    String? nameEn;
    String? nameAr;
    String? logo;
    String? category;
    String? country;
    String? city;
    String? domainUrl;

    Business({this.id, this.nameEn, this.nameAr, this.logo, this.category, this.country, this.city, this.domainUrl});

    Business.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        nameEn = json["name_en"];
        nameAr = json["name_ar"];
        logo = json["logo"];
        category = json["category"];
        country = json["country"];
        city = json["city"];
        domainUrl = json["domain_url"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["id"] = id;
        _data["name_en"] = nameEn;
        _data["name_ar"] = nameAr;
        _data["logo"] = logo;
        _data["category"] = category;
        _data["country"] = country;
        _data["city"] = city;
        _data["domain_url"] = domainUrl;
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