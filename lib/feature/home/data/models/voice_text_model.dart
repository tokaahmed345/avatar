
class VoiceTextModel {
    String? sessionId;
    String? sessionToken;
    String? message;

    VoiceTextModel({this.sessionId, this.sessionToken, this.message});

    VoiceTextModel.fromJson(Map<String, dynamic> json) {
        sessionId = json["session_id"];
        sessionToken = json["session_token"];
        message = json["message"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["session_id"] = sessionId;
        _data["session_token"] = sessionToken;
        _data["message"] = message;
        return _data;
    }
}