import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

/// Central currency formatting and EUR-based content conversion.
///
/// All monetary values in the app (games, lessons, UI) are authored in **EUR**.
/// [formatGame] converts from EUR into the user's selected display currency.
class CurrencyHelper {
  CurrencyHelper._();

  static const baseCurrency = 'EUR';

  /// Reference amount shown in Settings to preview exchange rates.
  static const settingsPreviewEurAmount = 1000.0;

  static const supported = ['EUR', 'MXN', 'USD', 'COP', 'ARS', 'CLP'];

  static const symbols = {
    'EUR': '€',
    'USD': '\$',
    'MXN': 'MX\$',
    'COP': 'COL\$',
    'ARS': 'ARS\$',
    'CLP': 'CL\$',
  };

  static const names = {
    'EUR': 'Euro',
    'USD': 'Dólar estadounidense',
    'MXN': 'Peso mexicano',
    'COP': 'Peso colombiano',
    'ARS': 'Peso argentino',
    'CLP': 'Peso chileno',
  };

  static String symbol(String currencyCode) =>
      symbols[currencyCode] ?? currencyCode;

  static String name(String currencyCode) =>
      names[currencyCode] ?? currencyCode;

  /// Settings / picker label, e.g. "Euro (€)" or "Peso mexicano (MX$)".
  static String settingsLabel(String currencyCode) =>
      '${name(currencyCode)} (${symbol(currencyCode)})';

  /// Settings picker line: €1000 for EUR, converted amount + EUR reference otherwise.
  static String settingsPreview(String currencyCode) {
    final converted = formatGame(settingsPreviewEurAmount, currencyCode);
    if (currencyCode == baseCurrency) return converted;
    final eurRef = formatGame(settingsPreviewEurAmount, baseCurrency);
    return '$converted · $eurRef';
  }

  /// Approximate rates vs EUR for display (lesson text + game UI scaling).
  static const ratesFromEur = {
    'EUR': 1.0,
    'USD': 1.09,
    'MXN': 21.5,
    'COP': 4700.0,
    'ARS': 1100.0,
    'CLP': 1050.0,
  };

  static double rate(String currencyCode) =>
      ratesFromEur[currencyCode] ?? 1.0;

  static double convertFromEur(double eurAmount, String currencyCode) =>
      eurAmount * rate(currencyCode);

  static bool useZeroDecimals(String currencyCode) =>
      currencyCode == 'COP' || currencyCode == 'CLP';

  static String format(
    double amount, {
    String currencyCode = 'EUR',
    bool compact = false,
  }) {
    final decimals = useZeroDecimals(currencyCode)
        ? 0
        : (compact ? 0 : 2);
    final value = decimals == 0
        ? amount.roundToDouble()
        : amount;
    final formatted = decimals == 0
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(decimals);

    switch (currencyCode) {
      case 'MXN':
        return '${symbol('MXN')}$formatted';
      case 'USD':
        return '${symbol('USD')}$formatted';
      case 'EUR':
        return '${symbol('EUR')}$formatted';
      case 'COP':
        return '${symbol('COP')}$formatted';
      case 'ARS':
        return '${symbol('ARS')}$formatted';
      case 'CLP':
        return '${symbol('CLP')}$formatted';
      default:
        return '\$$formatted';
    }
  }

  /// Game/economy values authored in EUR — scale + format for settings currency.
  static String formatGame(
    double eurBaseAmount,
    String currencyCode, {
    bool compact = false,
  }) {
    return format(
      convertFromEur(eurBaseAmount, currencyCode),
      currencyCode: currencyCode,
      compact: compact,
    );
  }

  /// Localize lesson/quiz strings that contain € or \$ amounts.
  static String localizeLessonText(String text, String currencyCode) {
    if (currencyCode == 'EUR') return text;

    var result = text;

    result = result.replaceAllMapped(
      RegExp(
        r'~?(\d{1,3}(?:\.\d{3})+(?:,\d+)?|\d+(?:,\d+)?)\s*-\s*~?(\d{1,3}(?:\.\d{3})+(?:,\d+)?|\d+(?:,\d+)?)\s*€',
      ),
      (m) {
        final low = formatGame(_parseEuropeanNumber(m.group(1)!), currencyCode, compact: true);
        final high = formatGame(_parseEuropeanNumber(m.group(2)!), currencyCode, compact: true);
        return '$low-$high';
      },
    );

    result = result.replaceAllMapped(
      RegExp(r'~?(\d{1,3}(?:\.\d{3})+(?:,\d+)?|\d+(?:,\d+)?)\s*€'),
      (m) {
        final prefix = m.group(0)!.startsWith('~') ? '~' : '';
        return '$prefix${formatGame(_parseEuropeanNumber(m.group(1)!), currencyCode)}';
      },
    );

    result = result.replaceAllMapped(
      RegExp(r'€\s*(\d{1,3}(?:\.\d{3})+(?:,\d+)?|\d+(?:,\d+)?)'),
      (m) => formatGame(_parseEuropeanNumber(m.group(1)!), currencyCode),
    );

    result = result.replaceAllMapped(
      RegExp(r'\$(\d{1,3}(?:,\d{3})*(?:\.\d+)?|\d+(?:\.\d+)?)'),
      (m) {
        final usd = _parseUsNumber(m.group(1)!);
        final eur = usd / rate('USD');
        return formatGame(eur, currencyCode);
      },
    );

    return result;
  }

  static double _parseEuropeanNumber(String raw) {
    final s = raw.trim();
    if (s.contains(',') && s.contains('.')) {
      return double.parse(s.replaceAll('.', '').replaceAll(',', '.'));
    }
    if (s.contains('.')) {
      final parts = s.split('.');
      if (parts.length > 1 && parts.last.length == 3) {
        return double.parse(s.replaceAll('.', ''));
      }
      return double.parse(s.replaceAll(',', '.'));
    }
    if (s.contains(',')) {
      return double.parse(s.replaceAll(',', '.'));
    }
    return double.parse(s);
  }

  static double _parseUsNumber(String raw) {
    return double.parse(raw.replaceAll(',', ''));
  }
}

extension CurrencyBuildContext on BuildContext {
  String get currencyCode => read<AppProvider>().currency;

  String money(double eurBaseAmount, {bool compact = false}) =>
      CurrencyHelper.formatGame(
        eurBaseAmount,
        currencyCode,
        compact: compact,
      );

  String localizeMoneyText(String text) =>
      CurrencyHelper.localizeLessonText(text, currencyCode);
}
