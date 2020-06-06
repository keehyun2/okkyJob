class Detail {
  String text;

  Detail(this.text);

  factory Detail.fromJson(dynamic json) {
    return Detail(json['text'] as String);
  }

  @override
  String toString() {
    return '{ ${this.text} }';
  }
}
