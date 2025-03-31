class PseudoValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le pseudo ne peut pas être vide';
    }

    if (value.length < 3) {
      return 'Le pseudo doit contenir au moins 3 caractères';
    }

    return null;
  }
}
