
class StopSessionModel {
    int? code;
    String? message;

    StopSessionModel({this.code, this.message});

    StopSessionModel.fromJson(Map<String, dynamic> json) {
        code = json["code"];
        message = json["message"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["code"] = code;
        _data["message"] = message;
        return _data;
    }
}