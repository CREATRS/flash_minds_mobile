class Word {
  const Word({
    this.en,
    this.es,
    this.fr,
    this.de,
    this.it,
    this.pt,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      en: json['en'],
      es: json['es'],
      fr: json['fr'],
      de: json['de'],
      it: json['it'],
      pt: json['pt'],
    );
  }

  final String? en;
  final String? es;
  final String? fr;
  final String? de;
  final String? it;
  final String? pt;

  String get(String? lang) {
    Map<String, String?> json = {
      'en': en,
      'es': es,
      'fr': fr,
      'de': de,
      'it': it,
      'pt': pt,
    };
    String? response = json[lang];
    response ??= json['en'];
    if (response == null) {
      String key = json.keys.firstWhere((k) => json[k] != null);
      response = json[key];
    }
    return response!.toUpperCase();
  }
}
