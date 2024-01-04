class Language {
  const Language({
    required this.code,
    required this.name,
    required this.specialCharacters,
  });

  final String code;
  final String name;
  final Map<String, List<String>> specialCharacters;
}

class Languages {
  static const Language english = Language(
    code: 'en',
    name: 'English',
    specialCharacters: {},
  );

  static const Language french = Language(
    code: 'fr',
    name: 'Français',
    specialCharacters: {
      'A': ['À', 'Â'],
      'C': ['Ç'],
      'E': ['É', 'È', 'Ê', 'Ë'],
      'I': ['Î', 'Ï'],
      'O': ['Ô'],
      'U': ['Û', 'Ù'],
      'Y': ['Ÿ'],
    },
  );

  static const Language german = Language(
    code: 'de',
    name: 'Deutsch',
    specialCharacters: {
      'A': ['Ä'],
      'O': ['Ö'],
      'S': ['ẞ'],
      'U': ['Ü'],
    },
  );

  static const Language italian = Language(
    code: 'it',
    name: 'Italiano',
    specialCharacters: {
      'A': ['À'],
      'E': ['È', 'É'],
      'I': ['Ì'],
      'N': ['Ñ'],
      'O': ['Ò'],
      'U': ['Ù'],
    },
  );

  static const Language portuguese = Language(
    code: 'pt',
    name: 'Português',
    specialCharacters: {
      'A': ['Á', 'À', 'Â', 'Ã'],
      'C': ['Ç'],
      'E': ['É', 'Ê'],
      'I': ['Í'],
      'O': ['Ó', 'Ô', 'Õ'],
      'U': ['Ú', 'Ü'],
    },
  );

  static const Language spanish = Language(
    code: 'es',
    name: 'Español',
    specialCharacters: {
      'A': ['Á'],
      'E': ['É'],
      'I': ['Í'],
      'N': ['Ñ'],
      'O': ['Ó'],
      'U': ['Ú', 'Ü'],
    },
  );

  static const List<Language> values = [
    english,
    spanish,
    french,
    portuguese,
    german,
    italian,
  ];

  static Language get(String code) {
    return values.firstWhere((element) => element.code == code);
  }
}
