import 'package:flutter_test/flutter_test.dart';
import 'package:finance4u/utils/streak_day_helper.dart';

void main() {
  group('StreakDayHelper', () {
    test('same Madrid streak day before and after 6 AM boundary', () {
      // 2026-05-20 05:30 Madrid (CEST) = 03:30 UTC → still previous streak day
      final beforeSix = DateTime.utc(2026, 5, 20, 3, 30);
      // 2026-05-20 06:30 Madrid (CEST) = 04:30 UTC → new streak day
      final afterSix = DateTime.utc(2026, 5, 20, 4, 30);

      expect(
        StreakDayHelper.streakDayIndex(beforeSix),
        StreakDayHelper.streakDayIndex(
          DateTime.utc(2026, 5, 19, 12),
        ),
      );
      expect(
        StreakDayHelper.streakDayIndex(afterSix),
        isNot(StreakDayHelper.streakDayIndex(beforeSix)),
      );
    });

    test('streak breaks after skipping one full streak day', () {
      final lastDay = StreakDayHelper.streakDayIndex(
        DateTime.utc(2026, 5, 18, 12),
      );
      final twoDaysLater = DateTime.utc(2026, 5, 20, 12);

      expect(
        StreakDayHelper.isStreakBroken(lastDay, twoDaysLater),
        isTrue,
      );
      expect(
        StreakDayHelper.isStreakBroken(
          lastDay,
          DateTime.utc(2026, 5, 19, 12),
        ),
        isFalse,
      );
    });
  });
}
