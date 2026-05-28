import '../utils/achievements_service.dart';

class ClassRankEntry {
  final String userId;
  final String username;
  final int points;
  final int pillsCompleted;
  final int topicsCompleted;
  final int streakDays;
  final int level;
  final String? photoUrl;
  final bool isCurrentUser;
  final List<String> completedLessons;

  const ClassRankEntry({
    required this.userId,
    required this.username,
    required this.points,
    this.pillsCompleted = 0,
    this.topicsCompleted = 0,
    this.streakDays = 0,
    this.level = 1,
    this.photoUrl,
    this.isCurrentUser = false,
    this.completedLessons = const [],
  });
}

class ClassMessage {
  final String id;
  final String userId;
  final String username;
  final String content;
  final DateTime? createdAt;

  const ClassMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.createdAt,
  });
}

/// Aggregated stats for the whole class.
class ClassStats {
  final int memberCount;
  final int activeMembers;
  final int totalPoints;
  final int totalPills;
  final int totalTopics;
  final int avgPoints;
  final int avgPills;
  final int avgTopics;
  final int avgLevel;
  final int maxStreak;
  final int chatMessages;
  final double participationRate;
  final double pillProgress;
  final double topicProgress;
  final int? userRank;
  final int userPoints;
  final int userPills;
  final int userTopics;
  final int pointsToLeader;
  final int? pointsToNextRank;
  final ClassRankEntry? mvp;
  final List<ClassRankEntry> topThree;
  final String? starTopicId;
  final int starTopicCompletions;
  final String? weakestTopicId;
  final int weakestTopicCompletions;
  final int idleMembers;
  final int avgStreak;
  final int maxPillsSingle;
  final int maxTopicsSingle;
  final ClassRankEntry? pillRecordHolder;
  final ClassRankEntry? streakRecordHolder;
  final ClassRankEntry? topicRecordHolder;
  final int topicsMasteredCount;
  final int topicsInProgressCount;
  final int basicPills;
  final int intermediatePills;
  final int advancedPills;
  final int userStreak;
  final int userLevel;
  final int pointsSpread;
  final int membersAboveAverage;
  final int chatAuthors;
  final int membersWithHalfPills;
  final int membersWithFullTopic;

  const ClassStats({
    this.memberCount = 0,
    this.activeMembers = 0,
    this.totalPoints = 0,
    this.totalPills = 0,
    this.totalTopics = 0,
    this.avgPoints = 0,
    this.avgPills = 0,
    this.avgTopics = 0,
    this.avgLevel = 1,
    this.maxStreak = 0,
    this.chatMessages = 0,
    this.participationRate = 0,
    this.pillProgress = 0,
    this.topicProgress = 0,
    this.userRank,
    this.userPoints = 0,
    this.userPills = 0,
    this.userTopics = 0,
    this.pointsToLeader = 0,
    this.pointsToNextRank,
    this.mvp,
    this.topThree = const [],
    this.starTopicId,
    this.starTopicCompletions = 0,
    this.weakestTopicId,
    this.weakestTopicCompletions = 0,
    this.idleMembers = 0,
    this.avgStreak = 0,
    this.maxPillsSingle = 0,
    this.maxTopicsSingle = 0,
    this.pillRecordHolder,
    this.streakRecordHolder,
    this.topicRecordHolder,
    this.topicsMasteredCount = 0,
    this.topicsInProgressCount = 0,
    this.basicPills = 0,
    this.intermediatePills = 0,
    this.advancedPills = 0,
    this.userStreak = 0,
    this.userLevel = 1,
    this.pointsSpread = 0,
    this.membersAboveAverage = 0,
    this.chatAuthors = 0,
    this.membersWithHalfPills = 0,
    this.membersWithFullTopic = 0,
  });

  String? get starTopicName {
    if (starTopicId == null) return null;
    return AchievementsService.topicDisplayNames[starTopicId!];
  }

  String? get weakestTopicName {
    if (weakestTopicId == null) return null;
    return AchievementsService.topicDisplayNames[weakestTopicId!];
  }

  int get userPercentile {
    if (memberCount <= 1 || userRank == null) return 100;
    return (((memberCount - userRank!) / (memberCount - 1)) * 100).round();
  }

  String get participationLabel {
    if (memberCount == 0) return '—';
    final pct = (participationRate * 100).round();
    if (pct >= 80) return '¡Clase on fire!';
    if (pct >= 50) return 'Buen ritmo';
    if (pct >= 25) return 'Despertando';
    return 'Arrancando';
  }

  static ClassStats fromData({
    required List<ClassRankEntry> ranking,
    required List<ClassMessage> messages,
    required String currentUserId,
    Map<String, int> topicCounts = const {},
  }) {
    if (ranking.isEmpty) return const ClassStats();

    final totalPoints = ranking.fold<int>(0, (s, e) => s + e.points);
    final totalPills = ranking.fold<int>(0, (s, e) => s + e.pillsCompleted);
    final totalTopics = ranking.fold<int>(0, (s, e) => s + e.topicsCompleted);
    final totalLevels = ranking.fold<int>(0, (s, e) => s + e.level);
    final activeMembers = ranking.where((e) => e.points > 0).length;
    final maxStreak = ranking.fold<int>(
      0,
      (s, e) => e.streakDays > s ? e.streakDays : s,
    );
    final n = ranking.length;

    ClassRankEntry? mvp;
    for (final e in ranking) {
      if (mvp == null || e.points > mvp.points) mvp = e;
    }

    int? userRank;
    var userPoints = 0;
    var userPills = 0;
    var userTopics = 0;
    for (var i = 0; i < ranking.length; i++) {
      if (ranking[i].userId == currentUserId) {
        userRank = i + 1;
        userPoints = ranking[i].points;
        userPills = ranking[i].pillsCompleted;
        userTopics = ranking[i].topicsCompleted;
        break;
      }
    }

    final leaderPoints = mvp?.points ?? 0;
    final pointsToLeader =
        userRank == 1 ? 0 : (leaderPoints - userPoints).clamp(0, 999999);

    int? pointsToNextRank;
    if (userRank != null && userRank > 1) {
      final above = ranking[userRank - 2];
      pointsToNextRank = (above.points - userPoints).clamp(1, 999999);
    }

    final maxPossiblePills = n * AchievementsService.totalPills;
    final maxPossibleTopics = n * AchievementsService.topicPills.length;
    final pillProgress = maxPossiblePills > 0
        ? (totalPills / maxPossiblePills).clamp(0.0, 1.0)
        : 0.0;
    final topicProgress = maxPossibleTopics > 0
        ? (totalTopics / maxPossibleTopics).clamp(0.0, 1.0)
        : 0.0;

    String? starTopicId;
    var starTopicCompletions = 0;
    String? weakestTopicId;
    var weakestTopicCompletions = 999999;
    if (topicCounts.isNotEmpty) {
      for (final entry in topicCounts.entries) {
        if (entry.value > starTopicCompletions) {
          starTopicId = entry.key;
          starTopicCompletions = entry.value;
        }
        if (entry.value < weakestTopicCompletions) {
          weakestTopicId = entry.key;
          weakestTopicCompletions = entry.value;
        }
      }
    } else {
      weakestTopicId = null;
      weakestTopicCompletions = 0;
    }

    final totalStreaks = ranking.fold<int>(0, (s, e) => s + e.streakDays);
    final avgPoints = (totalPoints / n).round();
    final halfPillsThreshold = (AchievementsService.totalPills / 2).ceil();

    ClassRankEntry? pillRecordHolder;
    ClassRankEntry? streakRecordHolder;
    ClassRankEntry? topicRecordHolder;
    for (final e in ranking) {
      if (pillRecordHolder == null ||
          e.pillsCompleted > pillRecordHolder.pillsCompleted) {
        pillRecordHolder = e;
      }
      if (streakRecordHolder == null ||
          e.streakDays > streakRecordHolder.streakDays ||
          (e.streakDays == streakRecordHolder.streakDays &&
              e.points > streakRecordHolder.points)) {
        streakRecordHolder = e;
      }
      if (topicRecordHolder == null ||
          e.topicsCompleted > topicRecordHolder.topicsCompleted) {
        topicRecordHolder = e;
      }
    }

    var userStreak = 0;
    var userLevel = 1;
    if (userRank != null) {
      final userEntry = ranking[userRank - 1];
      userStreak = userEntry.streakDays;
      userLevel = userEntry.level;
    }

    var basicPills = 0;
    var intermediatePills = 0;
    var advancedPills = 0;
    for (final entry in ranking) {
      for (final pill in entry.completedLessons) {
        final d = AchievementsService.pillDifficulty[pill];
        if (d == 1) {
          basicPills++;
        } else if (d == 2) {
          intermediatePills++;
        } else if (d == 3) {
          advancedPills++;
        }
      }
    }

    var topicsMasteredCount = 0;
    var topicsInProgressCount = 0;
    for (final count in topicCounts.values) {
      if (count > 0) topicsInProgressCount++;
      if (count >= n) topicsMasteredCount++;
    }

    final chatAuthors =
        messages.map((m) => m.userId).where((id) => id.isNotEmpty).toSet().length;

    final membersAboveAverage =
        ranking.where((e) => e.points > avgPoints).length;
    final membersWithHalfPills =
        ranking.where((e) => e.pillsCompleted >= halfPillsThreshold).length;
    final membersWithFullTopic =
        ranking.where((e) => e.topicsCompleted >= 1).length;

    final lastPoints = ranking.isNotEmpty ? ranking.last.points : 0;
    final pointsSpread = (leaderPoints - lastPoints).clamp(0, 999999);

    return ClassStats(
      memberCount: n,
      activeMembers: activeMembers,
      totalPoints: totalPoints,
      totalPills: totalPills,
      totalTopics: totalTopics,
      avgPoints: avgPoints,
      avgPills: (totalPills / n).round(),
      avgTopics: (totalTopics / n).round(),
      avgLevel: (totalLevels / n).round().clamp(1, 99),
      maxStreak: maxStreak,
      chatMessages: messages.length,
      participationRate: activeMembers / n,
      pillProgress: pillProgress,
      topicProgress: topicProgress,
      userRank: userRank,
      userPoints: userPoints,
      userPills: userPills,
      userTopics: userTopics,
      pointsToLeader: pointsToLeader,
      pointsToNextRank: pointsToNextRank,
      mvp: mvp,
      topThree: ranking.take(3).toList(),
      starTopicId: starTopicId,
      starTopicCompletions: starTopicCompletions,
      weakestTopicId: weakestTopicId,
      weakestTopicCompletions: weakestTopicCompletions,
      idleMembers: n - activeMembers,
      avgStreak: (totalStreaks / n).round(),
      maxPillsSingle: pillRecordHolder?.pillsCompleted ?? 0,
      maxTopicsSingle: topicRecordHolder?.topicsCompleted ?? 0,
      pillRecordHolder: pillRecordHolder,
      streakRecordHolder: streakRecordHolder,
      topicRecordHolder: topicRecordHolder,
      topicsMasteredCount: topicsMasteredCount,
      topicsInProgressCount: topicsInProgressCount,
      basicPills: basicPills,
      intermediatePills: intermediatePills,
      advancedPills: advancedPills,
      userStreak: userStreak,
      userLevel: userLevel,
      pointsSpread: pointsSpread,
      membersAboveAverage: membersAboveAverage,
      chatAuthors: chatAuthors,
      membersWithHalfPills: membersWithHalfPills,
      membersWithFullTopic: membersWithFullTopic,
    );
  }
}

class ClassRoomData {
  final String? groupName;
  final String? groupCode;
  final List<ClassRankEntry> ranking;
  final List<ClassMessage> messages;
  final ClassStats stats;
  final Map<String, int> topicCompletionCounts;

  const ClassRoomData({
    this.groupName,
    this.groupCode,
    this.ranking = const [],
    this.messages = const [],
    this.stats = const ClassStats(),
    this.topicCompletionCounts = const {},
  });

  static const empty = ClassRoomData();
}
