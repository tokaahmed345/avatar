
class StartSession {
    int? code;
    Data? data;
    String? message;

    StartSession({this.code, this.data, this.message});

    StartSession.fromJson(Map<String, dynamic> json) {
        code = json["code"];
        data = json["data"] == null ? null : Data.fromJson(json["data"]);
        message = json["message"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["code"] = code;
        if(data != null) {
            _data["data"] = data?.toJson();
        }
        _data["message"] = message;
        return _data;
    }
}

class Data {
    String? sessionId;
    String? livekitUrl;
    String? livekitClientToken;
    String? livekitAgentToken;
    int? maxSessionDuration;
    String? wsUrl;

    Data({this.sessionId, this.livekitUrl, this.livekitClientToken, this.livekitAgentToken, this.maxSessionDuration, this.wsUrl});

    Data.fromJson(Map<String, dynamic> json) {
        sessionId = json["session_id"];
        livekitUrl = json["livekit_url"];
        livekitClientToken = json["livekit_client_token"];
        livekitAgentToken = json["livekit_agent_token"];
        maxSessionDuration = json["max_session_duration"];
        wsUrl = json["ws_url"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["session_id"] = sessionId;
        _data["livekit_url"] = livekitUrl;
        _data["livekit_client_token"] = livekitClientToken;
        _data["livekit_agent_token"] = livekitAgentToken;
        _data["max_session_duration"] = maxSessionDuration;
        _data["ws_url"] = wsUrl;
        return _data;
    }
}