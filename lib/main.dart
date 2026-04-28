import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';

void main() async {
  // Flutter motorunun tam olarak başlatıldığından emin oluyoruz.
  // Asenkron AppInitializer ve Firebase başlatma kodları ileride buraya eklenecek.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DstekApp());
}

class DstekApp extends StatelessWidget {
  const DstekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DSTEK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // Klasik yönlendirme yerine GoRouter'ı sisteme tanıtıyoruz
      routerConfig: appRouter,
    );
  }
}