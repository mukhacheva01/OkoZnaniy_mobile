class ContactDetector {
  static final _patterns = [
    RegExp(r'\+?\d[\d\s\-\(\)]{7,}'), // phone numbers
    RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+'), // email
    RegExp(r'(telegram|tg|телеграм|whatsapp|вотсап|viber|вайбер)[\s:]*@?[\w\d_]+', caseSensitive: false),
    RegExp(r'@[\w\d_]{3,}'), // telegram handles
    RegExp(r'(vk\.com|t\.me|wa\.me|instagram\.com)/[\w\d_.]+', caseSensitive: false),
    RegExp(r'(скайп|skype|discord|дискорд)[\s:]*[\w\d#_.]+', caseSensitive: false),
  ];

  static bool containsContact(String text) {
    return _patterns.any((p) => p.hasMatch(text));
  }

  static String? findFirstMatch(String text) {
    for (final p in _patterns) {
      final match = p.firstMatch(text);
      if (match != null) return match.group(0);
    }
    return null;
  }
}
