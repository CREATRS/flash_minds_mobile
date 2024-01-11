import 'word.dart';

class WordPack {
  const WordPack({
    required this.id,
    required this.name,
    required this.words,
    required this.rating,
    required this.image,
    required this.languages,
  });

  factory WordPack.fromJson(Map<String, dynamic> json) {
    List<String>? languages;
    return WordPack(
      id: json['id'],
      name: json['name'],
      words: List<Word>.from(
        json['words'].map(
          (word) {
            List<String> keys = List<String>.from(word.keys);
            if (languages == null) {
              languages = keys;
            } else {
              languages = languages!..removeWhere((l) => !keys.contains(l));
            }
            return Word.fromJson(word);
          },
        ),
      ),
      rating: json['rating'].toDouble(),
      image: json['asset'],
      languages: languages!,
    );
  }

  final int id;
  final String name;
  final List<Word> words;
  final double rating;
  final String image;
  final List<String> languages;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'words': words,
        'rating': rating,
        'image': image,
      };
}
