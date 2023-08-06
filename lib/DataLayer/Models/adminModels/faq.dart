
class FAQ {
  String? answer;
  String? question;

  FAQ.fromMap(Map<String, dynamic> map) {
    this.answer = map["answer"];
    this.question = map["question"];
  }
  Map<String, String> toJson() {
    return {
      "answer": this.answer!,
      "question": this.question!,
    };
  }
}
