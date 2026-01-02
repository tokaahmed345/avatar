
class MessageModel {
    String? status;
    String? answer;

    MessageModel({this.status, this.answer});

    MessageModel.fromJson(Map<String, dynamic> json) {
        status = json["status"];
        answer = json["answer"];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> _data = <String, dynamic>{};
        _data["status"] = status;
        _data["answer"] = answer;
        return _data;
    }
}