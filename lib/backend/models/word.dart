class Word {
  Word({
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

  String? en;
  String? es;
  String? fr;
  String? de;
  String? it;
  String? pt;

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
    response ??= json.values.firstWhere((v) => v != null);
    return response!.toUpperCase();
  }

  String? getOrNull(String? lang) => {
        'en': en,
        'es': es,
        'fr': fr,
        'de': de,
        'it': it,
        'pt': pt,
      }[lang];

  bool hasLanguages(List<String> languages) =>
      languages.every((lang) => getOrNull(lang) != null);

  void remove(String lang) {
    switch (lang) {
      case 'en':
        en = null;
        break;
      case 'es':
        es = null;
        break;
      case 'fr':
        fr = null;
        break;
      case 'de':
        de = null;
        break;
      case 'it':
        it = null;
        break;
      case 'pt':
        pt = null;
        break;
    }
  }

  void set(String lang, String value) {
    switch (lang) {
      case 'en':
        en = value;
        break;
      case 'es':
        es = value;
        break;
      case 'fr':
        fr = value;
        break;
      case 'de':
        de = value;
        break;
      case 'it':
        it = value;
        break;
      case 'pt':
        pt = value;
        break;
    }
  }

  Map<String, String> toJson() {
    Map<String, String?> json = {
      'en': en,
      'es': es,
      'fr': fr,
      'de': de,
      'it': it,
      'pt': pt,
    };
    json.removeWhere((key, value) => value == null);
    return json.map((key, value) => MapEntry(key, value!));
  }
}
