import 'language.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.sourceLanguage,
    this.targetLanguage,
    this.avatar,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      sourceLanguage: Languages.get(json['source_language']),
      targetLanguage: Languages.get(json['target_language']),
      avatar: json['avatar'],
      token: json['token'],
    );
  }

  final int id;
  final String name;
  final String email;
  final Language? sourceLanguage;
  final Language? targetLanguage;
  final String? avatar;
  final String? token;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'source_language': sourceLanguage?.code,
      'target_language': targetLanguage?.code,
      'avatar': avatar,
      'token': token,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? sourceLanguage,
    String? targetLanguage,
    String? avatar,
    String? token,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      sourceLanguage: sourceLanguage == null
          ? this.sourceLanguage
          : Languages.get(sourceLanguage),
      targetLanguage: targetLanguage == null
          ? this.targetLanguage
          : Languages.get(targetLanguage),
      avatar: avatar ?? this.avatar,
      token: token ?? this.token,
    );
  }

  bool get hasLanguages => sourceLanguage != null && targetLanguage != null;
}
