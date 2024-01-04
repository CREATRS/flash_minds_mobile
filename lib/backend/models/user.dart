class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.sourceLanguage,
    this.targetLanguage,
    this.avatar,
    this.token,
    // this.purchasesUserId,
    // this.isPremium = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      sourceLanguage: json['source_language'],
      targetLanguage: json['target_language'],
      avatar: json['avatar'],
      token: json['token'],
      // purchasesUserId: json['purchases_user_id'],
      // isPremium: json['is_premium'],
    );
  }

  final int id;
  final String name;
  final String email;
  final String? sourceLanguage;
  final String? targetLanguage;
  final String? avatar;
  final String? token;
  // final String? purchasesUserId;
  // final bool isPremium;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
       'avatar': avatar,
      'token': token,
      // 'purchases_user_id': purchasesUserId,
      // 'is_premium': isPremium,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? sourceLanguage,
    String? targetLanguage,
    String? avatar,
    String? token,
    // String? purchasesUserId,
    // bool? isPremium,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      avatar: avatar ?? this.avatar,
      token: token ?? this.token,
      // purchasesUserId: purchasesUserId ?? this.purchasesUserId,
      // isPremium: isPremium ?? this.isPremium,
    );
  }

  bool get hasLanguages => sourceLanguage != null && targetLanguage != null;
}
