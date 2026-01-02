
class LogOutModel {
    String? detail;

    LogOutModel({this.detail});

    LogOutModel.fromJson(Map<String, dynamic> json) {
        detail = json["detail"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["detail"] = detail;
        return _data;
    }
}