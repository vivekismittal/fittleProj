extension StringExtension on String {
  String updateStringAtIndex(
    int index,
    String newCharacter,
  ) {
    if (index < 0 || index >= length) {
      // Handle invalid index
      return this;
    }

    List<String> characters = split('');
    characters[index] = newCharacter;
    String updatedString = characters.join('');

    return updatedString;
  }

bool isDecimalNumeric() {
    const numericRegex = r'^\d+(\.\d+)?$';
    final regExp = RegExp(numericRegex);
    return regExp.hasMatch(this);
  }
  bool isNumeric() {
    const numericRegex = r'^[0-9]+$';
    final regExp = RegExp(numericRegex);
    return regExp.hasMatch(this);
  }
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
  bool isValidEmail() {
    // Regular expression pattern for email validation
    final RegExp emailRegex = RegExp(
        r'([A-Za-z0-9]+[.-_])*[A-Za-z0-9]+@[A-Za-z0-9-]+(\.[A-Z|a-z]{2,})+');
    
    return emailRegex.hasMatch(this);
  }

}
