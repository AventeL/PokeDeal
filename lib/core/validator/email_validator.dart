class EmailValidator {
  static String? validate(String? email) {
    if (email == null || email.isEmpty) {
      return 'L\'email ne peux pas être vide';
    }
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(email)) {
      return 'Entrez un email valide';
    }
    return null;
  }
}
