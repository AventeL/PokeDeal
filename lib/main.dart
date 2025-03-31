import 'package:flutter/material.dart';
import 'package:pokedeal/core/di/injection_container.dart';
import 'package:pokedeal/core/materialApp/main_material_app.dart';
import 'package:pokedeal/features/authentication/domain/repository/authentication_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/config.dart';

void setupSupabase() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupSupabase();
  initInjectionDependencies();
  await getIt<AuthenticationRepository>().getUserProfile();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMaterialApp();
  }
}
