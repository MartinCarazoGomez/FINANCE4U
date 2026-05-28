/// Streak day boundaries at 06:00 Europe/Madrid (CET/CEST).
class StreakDayHelper {
  static const _resetHour = 6;

  /// Integer index for the current streak day (06:00 Madrid boundary).
  static int currentStreakDay([DateTime? instant]) {
    return streakDayIndex(instant ?? DateTime.now());
  }

  static int streakDayIndex(DateTime instant) {
    final madrid = toMadrid(instant);
    final adjusted = madrid.subtract(const Duration(hours: _resetHour));
    return DateTime(adjusted.year, adjusted.month, adjusted.day)
            .millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
  }

  static DateTime toMadrid(DateTime instant) {
    final utc = instant.toUtc();
    return utc.add(Duration(hours: madridUtcOffsetHours(utc)));
  }

  /// UTC offset for Europe/Madrid: CET +1, CEST +2.
  static int madridUtcOffsetHours(DateTime utc) {
    return isCEST(utc) ? 2 : 1;
  }

  /// CEST: last Sunday of March 01:00 UTC – last Sunday of October 01:00 UTC.
  static bool isCEST(DateTime utc) {
    final year = utc.year;
    final dstStart = lastWeekdayOfMonthUtc(year, 3, DateTime.sunday, 1);
    final dstEnd = lastWeekdayOfMonthUtc(year, 10, DateTime.sunday, 1);
    return !utc.isBefore(dstStart) && utc.isBefore(dstEnd);
  }

  static DateTime lastWeekdayOfMonthUtc(
    int year,
    int month,
    int weekday,
    int hourUtc,
  ) {
    var day = DateTime.utc(year, month + 1, 0).day;
    while (DateTime.utc(year, month, day).weekday != weekday) {
      day--;
    }
    return DateTime.utc(year, month, day, hourUtc);
  }

  static int daysSince(int? lastStreakDay, [DateTime? now]) {
    if (lastStreakDay == null) return 999;
    return currentStreakDay(now) - lastStreakDay;
  }

  /// Streak is lost if the user skipped at least one full streak day.
  static bool isStreakBroken(int? lastStreakDay, [DateTime? now]) {
    return daysSince(lastStreakDay, now) > 1;
  }
}
