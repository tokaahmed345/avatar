
class VoiceTextModel {
    String? status;
    String? answer;
    dynamic sessionToken;

    VoiceTextModel({this.status, this.answer, this.sessionToken});

    VoiceTextModel.fromJson(Map<String, dynamic> json) {
        status = json["status"];
        answer = json["answer"];
        sessionToken = json["session_token"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["status"] = status;
        _data["answer"] = answer;
        _data["session_token"] = sessionToken;
        return _data;
    }
}