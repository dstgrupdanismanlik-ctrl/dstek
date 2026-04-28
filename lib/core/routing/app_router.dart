import 'package:go_router/go_router.dart';
// Gerçek ekran dosyalarımızı içeri aktarıyoruz
import '../../core/init/app_initializer.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  // Uygulamanın başlangıç rotası artık AppInitializer (Splash Screen) oldu
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AppInitializer(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);