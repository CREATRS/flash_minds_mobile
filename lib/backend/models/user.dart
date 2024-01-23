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
    this.progress = const [],
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
      progress: List<UserProgress>.from(
        json['progress']['values']
            .map((progress) => UserProgress.fromJson(progress)),
      ),
    );
  }

  final int id;
  final String name;
  final String email;
  final Language? sourceLanguage;
  final Language? targetLanguage;
  final String? avatar;
  final String? token;
  final List<UserProgress> progress;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'source_language': sourceLanguage?.code,
      'target_language': targetLanguage?.code,
      'avatar': avatar,
      'token': token,
      'progress': progress.map((progress) => progress.toJson()).toList(),
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? sourceLanguage,
    String? targetLanguage,
    String? avatar,
    String? token,
    List<UserProgress>? progress,
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
      progress: progress ?? this.progress,
    );
  }

  bool get hasLanguages => sourceLanguage != null && targetLanguage != null;
}

class UserProgress {
  UserProgress({
    required this.id,
    required this.completed,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
        id: int.parse(json['word_pack_id']),
        completed: List<int>.from(json['completed_steps']),
      );

  final int id;
  final List<int> completed;

  Map<String, dynamic> toJson() => {'id': id, 'completed': completed};
}
