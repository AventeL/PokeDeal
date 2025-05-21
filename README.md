# 🃏 PokeDeal

**PokeDeal** est une application mobile de gestion de collections de cartes Pokémon, offrant
également une plateforme d’échange et de partage autour de cet univers.

---

## 🛠️ Installation

### Installation en local

- Installer [Android Studio](https://developer.android.com/studio) sur votre machine (optionnel mais
  recommandé)
- Installer flutter 3.29.2
- Créer un projet supabase
- cloner le projet et installer les dépendances

```bash
git clone https://github.com/AventeL/PokeDeal
cd PokeDeal
flutter pub get
```

- Créer un fichier lib/config/config.dart et y ajouter les informations de votre projet sous la
  forme
  suivante :

```dart

const supabaseUrl = 'supabaseUrl';
const supabaseKey = 'supabaseKey';
```

- Importer la base de données dans votre projet supabase avec le fichier disponible ici
  `supabase/migrations/20250520184527_remote_schema.sql` du projet en copiant le code dans le
  SqlEditor de supabase
- Ouvrez le projet dans Android Studio et exécutez-le sur un émulateur ou un appareil physique ou
  avec la commande suivante :

```bash
flutter run
```

### Installation via APK

- Télécharger l'APK depuis le lien suivant : 🔗https://github.com/AventeL/PokeDeal/releases/tag/v1
- Activer l’**installation d’applications de sources inconnues** dans les paramètres de sécurité de
  votre appareil Android
- Installer l’APK manuellement
- Lancer l'application depuis votre écran d'accueil

💡 *Vous pouvez aussi tester l’APK sur un émulateur (Android Studio) en glissant
simplement l’APK dans l’interface de l’émulateur.*

---

## Vidéo de démonstration

lien vers la vidéo de démonstration :  
[🔗 https://youtube.com/shorts/RSUdux-iwEg?feature=share](https://www.youtube.com/watch?v=2g1v0x4X8aE)

## 🎨 Design

- **Figma** (maquette UI) :  
  [🔗 https://www.figma.com/design/fsKdkxpSlihVzNsrDCUlHT/PokeDeal](https://www.figma.com/design/fsKdkxpSlihVzNsrDCUlHT/PokeDeal?node-id=0-1&t=24J2waAvHNUpwi87-1)

---

## 📄 Livrables

- 📘 **Livrable 1
  ** : [Lien vers le document](https://docs.google.com/document/d/11KTpuKqffrWx-szyO72RQN0qIWPW4NdKu7WLj5waNBU/edit?usp=sharing)
- 📙 **Livrable 2
  ** : [Lien vers le document](https://docs.google.com/document/d/1MnC-Qc47OciStTeqMgjH7TCSyce76CSIq-iRLxspdNs/edit?usp=sharing)
- 📗 **Livrable 3
  ** : [Lien vers le document](https://docs.google.com/document/d/1GtcCkhAS0JCGFDSxLC0hy2SsbQFXTKJssKmw4-xDeAc/edit?usp=sharing)
- ✅ **Document de recettage
  ** : [Lien vers le document](https://docs.google.com/document/d/1Kpj16n2Skj8a6MPe-FseexXcbTAVsMD5tquDa4-02M4/edit?usp=sharing)

---

## 📬 Contact

Pour toute question, suggestion ou bug, n’hésitez pas à me contacter directement.

---
