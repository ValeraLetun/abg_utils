class StringData{
  String code = "";
  String text = "";

  StringData({this.code = "", this.text = ""});

  Map<String, dynamic> toJson() => {
    'code': code,
    'text': text,
  };

  factory StringData.fromJson(Map<String, dynamic> data){
    return StringData(
      code: (data["code"] != null) ? data["code"] : "",
      text: (data["text"] != null) ? data["text"] : "",
    );
  }

  factory StringData.createEmpty(){
    return StringData();
  }
}
