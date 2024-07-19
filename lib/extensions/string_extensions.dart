extension StringExtensions on String {
  bool get isUppercase {
    if (isEmpty) return false;
    int ascii = codeUnitAt(0);
    return ascii >= 65 && ascii <= 90;
  }
}
