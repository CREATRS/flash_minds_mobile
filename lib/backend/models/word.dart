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

  String get(String lang) => {
        'en': en,
        'es': es,
        'fr': fr,
        'de': de,
        'it': it,
        'pt': pt,
      }[lang]!
          .toUpperCase();
}
