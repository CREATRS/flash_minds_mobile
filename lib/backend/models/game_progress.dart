class GameProgress {
  const GameProgress({
    this.currentScore = 0,
    this.completedWordPacks = const [],
  });

  final int currentScore;
  final List<int> completedWordPacks;

  GameProgress addWordPack(int wordPackId) => GameProgress(
        currentScore: currentScore,
        completedWordPacks: [...completedWordPacks, wordPackId],
      );

  GameProgress increaseScore() => GameProgress(
        currentScore: currentScore + 1,
        completedWordPacks: completedWordPacks,
      );
}
