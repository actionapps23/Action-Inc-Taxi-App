class Utils {
  /// Capitalizes the first letter of a word and makes the rest lowercase.
  static String capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  // Add more helper functions as needed
}
