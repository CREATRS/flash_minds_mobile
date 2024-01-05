import 'dart:math';

import 'package:flutter/material.dart' show AnimationController;

import 'package:flash_minds/backend/models/game_progress.dart';
import 'package:flash_minds/backend/models/language.dart';
import 'package:flash_minds/backend/models/word.dart';
import 'package:flash_minds/backend/models/wordpack.dart';

export 'package:flash_minds/backend/models/game_progress.dart';

class GameController {
  GameController({
    required this.wordPack,
    required this.sourceLanguageCode,
    required this.targetLanguage,
    this.preloadProgress,
  }) {
    reset();
    _progress = preloadProgress ?? const GameProgress();
    _score = _progress.currentScore;
  }

  final WordPack wordPack;
  final String sourceLanguageCode;
  final Language targetLanguage;
  final GameProgress? preloadProgress;

  final List<String> attempts = [];
  AnimationController? animationController;

  double _animationTarget = 0;
  final List<String> _completedWords = [];
  late String _currentWord;
  late String _currentWordSource;
  late List<String> _characters;
  bool _isReady = true;
  late GameProgress _progress;
  late int _score;
  bool? _win;

  // Public methods
  Future<bool> attempt(String s) async {
    attempts.add(s);
    if (_currentWord.contains(s)) {
      if (_currentWord
          .split('')
          .every((element) => attempts.contains(element))) {
        _win = true;
        if (!_progress.completedWordPacks.contains(wordPack.id)) {
          _score++;
          _progress = _progress.increaseScore();
        }
        await _finish();
      }
      return true;
    } else {
      await _next();
      if (animationController!.value * 11 > 5) {
        _win = false;
        await _finish();
      }
      return false;
    }
  }

  Future<void> reset({bool clearScore = true}) async {
    if (!_isReady) return;

    _isReady = false;
    if (animationController != null) await _reverse();

    if (clearScore) {
      _score = 0;
      _completedWords.clear();
    }

    List<Word> availableWords = wordPack.words
        .where((w) => !_completedWords.contains(w.get(targetLanguage.code)))
        .toList();
    if (availableWords.isEmpty) {
      _isReady = true;
      return;
    }
    _win = null;
    Word word = availableWords[Random().nextInt(availableWords.length)];
    _currentWord = word.get(targetLanguage.code);
    _currentWordSource = word.get(sourceLanguageCode);

    _characters = 'QWERTYUIOPASDFGHJKLZXCVBNM'.split('');
    attempts.clear();
    if (_currentWord.contains(' ')) {
      attempts.add(' ');
    }
    _isReady = true;
  }

  // Private methods
  Future<void> _finish() async {
    if (animationController!.value * 11 >= 6) return;
    _isReady = false;
    _completedWords.add(_currentWord);
    if (isWordPackCompleted) {
      _progress = _progress.addWordPack(wordPack.id);
    }
    if (animationController!.value * 11 < 5) {
      animationController!.value += 6 / 11;
    }
    _animationTarget = animationController!.value + 1 / 11;
    await animationController!.animateTo(_animationTarget);
    _isReady = true;
  }

  Future<void> _next() async {
    if (_win != null) return;
    _isReady = false;
    _animationTarget += (1 / 11);
    await animationController!.animateTo(_animationTarget);
    _isReady = true;
  }

  Future<void> _reverse() async {
    _isReady = false;
    if (animationController!.value * 11 < 6) {
      _animationTarget = 0;
      await animationController!.reverse();
    } else {
      _animationTarget -= (1 / 11);
      await animationController!.animateBack(_animationTarget);
      _animationTarget = 0;
      animationController!.value = 0;
    }
    _isReady = true;
  }

  // Getters/Setters
  String get currentWord => _currentWord;
  String get currentWordSource => _currentWordSource;
  List<String> get characters => _characters;
  bool get isReady => _isReady && _win == null;
  int get score => _score;
  bool? get win => _win;
  bool get isWordPackCompleted =>
      _completedWords.length == wordPack.words.length;
  GameProgress get progress => _progress;
  int get wrongAttempts =>
      attempts.where((c) => !_currentWord.contains(c)).length;
}
