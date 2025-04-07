import 'package:flutter_test/flutter_test.dart';
import 'package:pokedeal/core/validator/email_validator.dart';
import 'package:pokedeal/core/validator/password_validator.dart';
import 'package:pokedeal/core/validator/pseudo_validator.dart';

void main() {
  test('email validator', () {
    String goodMail = "test@mail.com";
    String badMail = "testmail.com";
    String emptyMail = "";
    String? result = EmailValidator.validate(goodMail);
    String? result2 = EmailValidator.validate(badMail);
    String? result3 = EmailValidator.validate(emptyMail);
    String? result4 = EmailValidator.validate(null);

    expect(result, null);
    expect(result2, "Entrez un email valide");
    expect(result3, "L'email ne peut pas être vide");
    expect(result4, "L'email ne peut pas être vide");
  });

  test('password validator', () {
    String goodPassword = "password";
    String badPassword = "pass";
    String emptyPassword = "";
    String? result = PasswordValidator.validate(goodPassword);
    String? result2 = PasswordValidator.validate(badPassword);
    String? result3 = PasswordValidator.validate(emptyPassword);
    String? result4 = PasswordValidator.validate(null);

    expect(result, null);
    expect(result2, "Le mot de passe doit contenir au moins 6 caractères");
    expect(result3, "Le mot de passe ne peut pas être vide");
    expect(result4, "Le mot de passe ne peut pas être vide");
  });

  test('pseudo validator', () {
    String goodPseudo = "test";
    String badPseudo = "te";
    String emptyPseudo = "";
    String? result = PseudoValidator.validate(goodPseudo);
    String? result2 = PseudoValidator.validate(badPseudo);
    String? result3 = PseudoValidator.validate(emptyPseudo);
    String? result4 = PseudoValidator.validate(null);

    expect(result, null);
    expect(result2, "Le pseudo doit contenir au moins 3 caractères");
    expect(result3, "Le pseudo ne peut pas être vide");
    expect(result4, "Le pseudo ne peut pas être vide");
  });
}
